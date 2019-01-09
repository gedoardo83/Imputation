#Remove het call in male samples in NON-PAR regions
#ARGV[0] = vcf of chrX for all samples
#ARGV[1] = list of samples with sex code (1 male / 2 female) in the same order as VCF samples

open(IN, $ARGV[1]);
$n=8;
while ($row=<IN>) {
  $n++;
  chomp($row);
  @line = split(" ", $row);
  if ($line[1] == 1) {push(@males, $n)}
}
close(IN);

open(IN, $ARGV[0]);
while ($row=<IN>) {
  chomp($row);
  if ($row =~ /^#/) {
    print "$row\n";
    next;
  }

  @line = split("\t", $row);
  foreach $id(@males) {
    if ($line[1] >= 2699520 && $line[1] <= 154931043 && $line[$id] eq "0/1") {$line[$id] = "./."}
  }
  print join("\t", @line)."\n";
}
close(IN);
