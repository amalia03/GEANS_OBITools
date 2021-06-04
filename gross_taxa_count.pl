($infile) = @ARGV;

open(IN, $infile) || die "unable to open $infile $!\n";

$id = "";
$q_count = 0;

while(<IN>){
    chomp;
    @tmp = split /\t/, $_;
    $new_id = $tmp[0];
    next if($new_id eq $id);
    $id = $new_id;
    $sp = $words[2];
    $sp = $tmp[2];
    $tax{$sp}++;
    $q_count++;
    push @{$al_lengths{$sp}}, $tmp[12];
    push @{$p_ids{$sp}}, $tmp[12];
    push @{$scores{$sp}}, $tmp[10];
    $al_length_sum{$sp} += $tmp[11];
    $p_ids_sum{$sp} += $tmp[12];
    $scores_sum{$sp} += $tmp[10];
}
    print "sp_name","\t",
    "sp_nmbr","\t",
    "proportion_sp_to_query","\t",
    "sp_mean_alilength","\t",
    "sp_mean_pid","\t",
    "sp_mean_ score","\n";
for $sp( sort { $tax{$a} <=> $tax{$b}  } keys %tax ){
    @{$al_lengths{$sp}} = sort( {$a <=> $b} @{$al_lengths{$sp}} );
    @{$p_ids{$sp}} = sort( {$a <=> $b} @{$p_ids{$sp}} );
    @{$scores{$sp}} = sort( {$a <=> $b} @{$scores{$sp}} );

    print $sp, "\t", $tax{$sp}, "\t", $tax{$sp} / $q_count,
    "\t", $al_length_sum{$sp} / $tax{$sp},
    "\t", $p_ids_sum{$sp} / $tax{$sp},
    "\t", $scores_sum{$sp} / $tax{$sp}, "\n";
}
