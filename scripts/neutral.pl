
print "���n�ഫ�{��    2000 �~���� 3 �骩\n\n";

open (NEUTRAL, "neutral.lst") || die "Cannot open neutral-tone list file neutral.lst\n";
while (<NEUTRAL>) {
        ($orig, $new) = split;
        $neutral{$orig} = $new;
}
close (NEUTRAL);
$num_neutral = keys %neutral;
print "�� neutral.lst �����o $num_neutral �ջ��n�ഫ\n";

$start = -1;
while (($start < 0) || ($start > 446)) {
        print "�п�J�_�l�ɮ׽s�� (0 ~ 446)�G";
        $start = <STDIN>;
        chop ($start);
}

$stop = -1;
while (($stop < $start) || ($stop > 446)) {
        print "�п�J�����ɮ׽s�� ($start ~ 446)�G";
        $stop = <STDIN>;
        chop ($stop);
}

$yes = 0;
while ($yes == 0) {
        print "�A�T�w�n�ഫ $start �ɮר� $stop �ɮ׶ܡH (y/n) ";
        $ch = <STDIN>;
        chop ($ch);
        if ($ch =~ /^(y|Y)$/) {
                $yes = 1;
        } elsif ($ch =~ /^(n|N)$/) {
                die;
        }
}

open (OUTPUT, ">neutral.out") || die "Cannot open output file neutral.out\n";
print "\n�����b��Z�W�ഫ�A�åB�N�L�{�O���b neutral.out �o���ɮפ��C\n�ഫ���A�еy��...\n";
$oldfh = select (OUTPUT);

$false = 0;
for ($i = $start; $i <= $stop; $i++) {
        $fn = $i;
        $fn = "0" . $fn if $i < 100;
        $fn = "0" . $fn if $i < 10;
        $fn_new = "c:\\dic\\" . $fn . ".new";
        $fn = "c:\\dic\\" . $fn . ".dic";

        open (FILE, $fn) || die "Cannot open input file $fn\n";
        open (FILE_NEW, ">$fn_new") || die "Cannot open output file $fn_new\n";

        while (<FILE>) {
                foreach $orig (keys %neutral) {
                        $found = index ($_, $orig);
                        while ($found != -1) {
                                $offset = 0;
                                while ($offset < $found) {
                                        $c = ord (substr ($_, $offset));
                                        if ((0x81 <= $c) && ($c <= 0xFE)) {
                                                $offset += 2;
                                        } else {
                                                $offset++;
                                        }
                                }
                                if ($offset == $found) {
                                        print "$fn �ɮ�\t�� $. ��\n$_";
                                        $_ = substr($_, 0, $found) . $neutral{$orig}
                                           . substr($_, $found+length($orig));
                                        print "$_";
                                        print " "x$found . "^"x(length($neutral{$orig})) . "\n";
                                } else {
                                        $false++;
                                }
                                $found = index ($_, $orig, $found+1);
                        }
                }
                print FILE_NEW $_;
        }

        close (FILE);
        close (FILE_NEW);
        unlink ($fn);
        rename ($fn_new, $fn);
}

print "�L�{���@�o�� $false ����ĵ��\n";
select ($oldfh);
close (OUTPUT);
