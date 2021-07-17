#!/usr/bin/env perl

use v5.18;
# use utf8;

use YAML::PP;
use XXX;

my ($YYYY, $MM, $DD);
my (@lvl) = (0, 0, 0, 0);
my $links = {};

sub main {
  my ($front, $markdown, $link_map) = read_files(@_);

  my $parsed = parse_sections($markdown);

  set_vars();
  make_link_index($parsed, $link_map);

  my @sections;
  for my $section (@$parsed) {
    my ($key) = keys %$section;
    my $method = "fmt_$key";
    $_ = $section->{$key};
    main->$method;
    push @sections, $_;
  }

  print "$front";
  print join "\n", @sections;
}

#------------------------------------------------------------------------------
my $re_pre = qr/
  ```\n
  (?:.*\n)+?
  ```\n
/x;
my $re_legend = qr/
  \*\*Legend:\*\*\n
  (?:\*\ .*\n)+
/x;

sub parse_sections {
  ($_) = @_;

  my @s;
  while ($_) {
    # HTML block:
    if (/\A<([a-z]+)[^>]*>\n/) {
      my $tag = $1;
      s{\A(<$tag.*\n(?:.*\n)*?</$tag>\n)}{}
        and push @s, {html_block => $1} and next;
    }

    # Headings:
    s/\A(\S.*\n)===+\n\n+//
      and push @s, {heading => "# $1"} and next;

    s/\A(#{1,5} .*\n)\n+//
      and push @s, {heading => $1} and next;

    # Example section:
    s/\A
      (\*\*Example\ \# [\s\S]*?\*\*)\n
      ($re_pre)
      ($re_pre)?
      ($re_legend)?
      \n+
    //x
      and push @s, {example => [$1, $2, $3, $4]} and next;

    s/\A
      (
        (::.*\n)?
        (?:
          (?:\*\ \S.*\n)
          (?:
            (?:
              \n
              (\ \ \S.*\n)+
            )+
            \n?
          )?
          (?:\ \ \*\ .*\n)*
        )+
        (?:\{:\.\S+\}\n)?
      )
      \n+
    //x
      and push @s, {ul => $1} and next;

    s/\A
      (
        (?:
          (?:\*\*|-1\ |\[[\w\"\*]|[\w\"\(])
          .*\n
        )+
      )
      (?:
        (?=```) |
        \z |
        \n+
      )
    //x
      and push @s, {p => $1} and next;

    s/\A(----\n)\n+//
      and push @s, {hr => $1} and next;

    s/\A\::toc\n\n+//
      and push @s, {toc => 1} and next;

    s/\A\::index\n//
      and push @s, {index => 1} and next;

    s/\A((?:>.*\n)+)\n+//
      and push @s, {indent => $1} and next;

    s/\A((?s:```.+?\n```\n))\n+//
      and push @s, {pre => $1} and next;

    s/\A(!\[.*\.png\)\n)\s+//
      and push @s, {img => $1} and next;

    s/\A(\* .*\n(?:  \S.*\n|\n(?=  \S))+)\n+//
      and push @s, {ul => $1} and next;

    s/\A(\`\w.*\n)\n+//
      and push @s, {p => $1} and next;

    s/\A((?:\| .*\n)+)\n+//
      and push @s, {table => $1} and next;

    s/\A((?:\* .*\n)(?:  .*\n|\n(?=  ))+)\n+//
      and push @s, {ul => $1} and next;

    s/\A(<!--(?:.*\n)+?-->\n)\n*//
      and push @s, {comment => $1} and next;

    s/\n+\z// and next;

    s/((?:.*\n){20})(?s:.*)/$1/;
    WWW(\@s);
    die "*** ERROR ***\nParse failed at this point:\n$_\n*** EOF ***\n";
  }

  return \@s;
}

#------------------------------------------------------------------------------
sub fmt_html_block {
  s/\A<([a-z]+)(.*)>\n// or die;
  my $out = $_;
  my $tag = $1;
  my $more = $2;
  $more =~ s/^\s*(.*?)\s*$/$1/;
  my $id;
  my @class;
  my @attrs;
  if (not grep /^$tag$/, qw(div table blockquote)) {
    push @class, $tag;
    $tag = 'div';
  }
  while ($more) {
    $more =~ s/^\.([-a-z0-9]+)\s*// and push @class, $1 and next;
    $more =~ s/^\#([-a-z]+)\s*// and $id = $1 and next;
    ( $more =~ s/^([-a-z]+)=([-a-z0-9]+)\s*// or
      $more =~ s/^([-a-z]+)="([^"]*)"\s*//
    ) and do {
      my $attr = $1;
      my $val = $2;
      $attr = "data-$attr" unless
        $attr =~ /^(?:(?:id|class|style)$|data-)/;
      push @attrs, qq{$attr="$val"};
      next;
    };
    die "Parse html_block failed here: '$more'";
  }
  my $line = "<$tag";
  if ($id) {
    $line .= qq{ id="$id"};
  }
  if (@class) {
    $line .= qq< class="${\ join ' ', @class}">;
  }
  if (@attrs) {
    $line .= qq< ${\ join ' ', @attrs}>;
  }
  $line .= ">\n";
  $out =~ s{</\w+>\n\z}{</$tag>};
  $_ = "$line$out";
}

sub fmt_heading {
  set_dates();
  set_heading_level();

  return unless /\d\.\s/;

  my $text = $_;
  my $slug = slugify($text);

  $_ = qq{<div id="$slug" />\n$text\n};
}

sub fmt_example {
  my ($title, $yaml1, $yaml2, $legend) = @$_;

  my $id = $title;
  $id =~ s/\s*\(.*//s;
  $id = slugify($id);

  my $out = set_example_level($title) . "\n\n";

  if ($legend) {
    $yaml1 = apply_legend($yaml1, $legend);
  }
  else {
    $yaml1 = format_pre($yaml1);
  }

  if ($yaml2) {
    $yaml2 = format_pre($yaml2);
    if ($yaml2 =~ /ERROR:/) {
      $yaml1 =~ s/<pre(\ ?)/<pre class="error"$1/;
      $yaml2 =~ s/<pre(\ ?)/<pre class="error"$1/;
    }
    $out .= <<"...";
<table width="100%">
<tr>
<td class="side-by-side">
$yaml1
</td>
<td class="side-by-side">
$yaml2
</td>
</tr>
</table>
...
  }
  else {
    $yaml1 =~ s/<pre>/<pre class="example">/;
    $out .= "$yaml1\n";
  }

  if ($legend) {
    $_ = format_legend($legend);
    $out .= <<"...";
<div class="legend" markdown=1>
$_
</div>
...
  }

  chomp $out;

#   die $out if $out =~ /<code/;

  $_ = <<"...";
<div id="$id" class="example">
$out
</div>
...
}

sub fmt_ul {
  undefined_links();
}

my $figure = 0;
sub fmt_p {
  set_dates();
  undefined_links();
  if (/^\*\*Figure #\./m) {
    my $chapter = $lvl[0];
    $figure++;
    s/^\*\*Figure #\./**Figure $chapter.$figure./;
  }
}

sub fmt_hr {}

sub fmt_indent {
  undefined_links();
}

my $num = 0;
sub fmt_pre {
  my $pre = format_pre($_);
  if (/(\S+)\s+::=/) {
    my $rule = $1;
    $num++;
    $pre =~ s/\[\#\]/[$num]/;
    $pre =~ s/<pre>/<pre class="rule">/;
    # $pre =~ s/(\b(?:ns|nb|s|l)-\S*)/<a href="rule-$1">$1<\/a>/g;
    chomp $pre;
    $pre = <<"...";
<div id="rule-$rule" />
$pre
...
  }
  $_ = $pre;
}

sub fmt_comment {}

sub fmt_img {}

sub fmt_table {}

sub fmt_toc {
  $_ = <<'...';
* TOC
{:toc}
...
}

sub fmt_index {
  $_ = <<'...';
# Index
...
}

#------------------------------------------------------------------------------
sub read_files {
  my ($root, $markdown_file, $links_file) = @_;
  my ($front, $markdown, $links);
  $markdown = read_file($markdown_file);
  if ($markdown =~ s/\A(---\n.*?\n---\n)//s) {
    $front = $1;
  }
  else {
    $front = "---\n---\n";
  }
  if ($links_file) {
    $links = YAML::PP::LoadFile($links_file);
  }
  else {
    $links = {};
  }
  my $yaml = $front;
  $yaml =~ s/\A---\n//;
  $yaml =~ s/---\n\z//;
  if ($yaml) {
    my $data = YAML::PP::Load($yaml);
    if (my $source = $data->{source}) {
      $markdown = read_file("$root/$source");
    }
  }
  $markdown .= "\n";
  return ($front, $markdown, $links)
}

sub read_file {
  my ($file) = @_;
  open my $fh, '<:encoding(UTF-8)', $file;
  local $/;
  <$fh>;
}

sub set_vars {
  my ($d,$m,$y);
  ($_,$_,$_,$d,$m,$y) = localtime;
  $YYYY = 1900 + $y;
  $MM = sprintf "%02d", $m + 1;
  $DD = sprintf "%02d", $d;
}

sub make_link_index {
  my ($parsed, $overrides) = @_;
  for my $section (@$parsed) {
    my $from = $section->{hx};
    my $text = lc($from);
    chomp $text;
    $text =~ /^#+\s+.*#\.\s/ or next;
    $text =~ s/^#+\s+//;
    $text =~ s/^chapter\s+//;
    $text =~ s/^#\.\s+//;
    $text =~ s/[\"\*\`]//g;
    my $slug = slugify($text);
    $links->{$text} = $slug;
  }
  for my $k (keys %$overrides) {
    $links->{$k} = $overrides->{$k};
  }
}

sub slugify {
  my ($slug) = @_;

  $slug =~ s/#+\s+Chapter\s\d+\.\s+//;
  $slug =~ s/^#+\s+(\d+\.)+//;
  $slug = lc $slug;
  $slug =~ s/[^a-z0-9]/-/g;
  $slug =~ s/-+/-/g;
  $slug =~ s/^-//;
  $slug =~ s/-$//;

  return $slug;
}

sub get_link {
  my ($link) = @_;
  if (my $anchor = $links->{lc($link)}) {
    return "[$link](#$anchor)";
  }
  else {
    return "~~[$link](#undefined)~~";
  }
}

sub undefined_links {
  s/\[([^-0-9\`\]][^\]]*?)\](?=[^\(\`])/get_link($1)/sge;
}

sub set_dates {
  s/YYYY/$YYYY/g;
  s/MM/$MM/g;
  s/DD/$DD/g;
}

my $example_number;
sub set_heading_level {
  /^(#+)\ .*#\./ or return;
  my $lvl = length $1;
  my $txt = '';
  for (my $i = 0; $i < 4; $i++) {
    if ($i < $lvl) {
      if ($i == $lvl - 1) {
        $lvl[$i]++;
      }
      $txt .= $lvl[$i] . '.';
    }
    else {
      $lvl[$i] = 0;
    }
  }
  s/#\./$txt/;

  $example_number = 0 if $lvl == 1;
}

sub set_example_level {
  my ($title) = @_;
  my $chapter = $lvl[0];
  $example_number++;
  $title =~ s/\#\./$chapter.$example_number/;
  return $title;
}

sub apply_legend {
  my ($yaml, $legend) = @_;
  my @lines = split /\n/, $legend;
  my @rules;
  for my $line (@lines) {
    if ($line =~ /<!--/) {
      $line =~ s/.*<!--\s+(.*?)\s+-->/$1/;
      push @rules, [split /\s+/, $line];
    }
  }

  $yaml =~ s/\A```\n//;
  $yaml =~ s/\n```\n\z//;
  XXX $yaml if /(?:\[%|%\])/;

  @lines = split /\n/, $yaml;
  my @chars = map
    [ split //, $_ ],
    @lines;

  my $i = @rules + 1;
  for my $rule (reverse @rules) {
    $i--;
    for my $r (@$rule) {
      next unless $r =~ /^[1-9]/;
      $r =~ /^([1-9]\d*)(?::(\d+)(,\d*)?)?$/
        or XXX $r;
      my ($row, $col, $end) = ($1, $2, $3);
      my $len = @{$chars[--$row]} - 1;
      if ($col) {
        $col--;
        if ($end) {
          $end =~ s/^,// or die;
          if ($end eq '') { $end = $len }
          else { $end = $col + $end - 1 }
        }
        else { $end = $col }
      }
      else { $col = 0; $end = $len }
      $chars[$row]->[$col] =~ s{^}{[%code class="legend-$i"%]};
      $chars[$row]->[$end] =~ s{$}{[%/code%]};
    }
  }

  $yaml = join "\n",
    map { $_ = join '', @$_ }
    @chars;

  my $i = 0;
  for my $rule (@rules) {
    $i++;
    my @re;
    for my $r (@$rule) {
      next if $r =~ /^[1-9]/;
      $r =~ s/^0//;
      $r =~ s/([\"\'\!\*\+\?\|\{\}\[\]\(\)\.\\])/\\$1/g;
      $r =~ s/_/\\ /g;
      push @re, $r;
    }
    next unless @re;
    my $re = '(' . join('|', @re) . ')';
    $yaml =~ s{$re}{[%code class="legend-$i"%]${1}[%/code%]}g;
  }

  $yaml =~ s/&/&amp;/g;
  $yaml =~ s/</&lt;/g;
  $yaml =~ s/>/&gt;/g;
  $yaml =~ s/\[%/</g;
  $yaml =~ s/%\]/>/g;

  return <<"...";
<pre>
$yaml
</pre>
...
}

sub format_pre {
  $_ = $_[0];

  s/\A```\n//;
  s/\n```\n\z//;
  s/&/&amp;/g;
  s/</&lt;/g;
  s/>/&gt;/g;

  return <<"...";
<pre>
$_
</pre>
...
}

sub format_legend {
  $_ = $_[0];
  chomp;
  s/\s*<!--.*-->//g;
  my @lines = split /\n/, $_;
  my $i = 0;
  for (@lines) {
    if (/\[/) {
      $i++;
      s{\[([^\]]+)\]}{<code class="legend-$i">[$1]</code>}g;
    }
  }
  $_ = join "\n", @lines;
  s{\[([^\]]+)\]}{<a href="#rule-$1">$1</a>}g;
  s/^/> /mg;
  return $_;
}

main @ARGV;
