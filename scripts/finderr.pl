
print "��Z�榡�`�ǿ��~�ˬd�{��    2000 �~ 2 �� 12 �骩\n\n";

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

open (OUTPUT, ">finderr.out") || die "Cannot open output file finderr.out\n";
print "\n�ˬd�쪺���~�N�|�g�b finderr.out �o���ɮפ��C\n�ˬd���A�еy��...\n";
$oldfh = select (OUTPUT);

for ($i = $start; $i <= $stop; $i++) {
        $fn = $i;
        $fn = "0" . $fn if $i < 100;
        $fn = "0" . $fn if $i < 10;
        $fn = "c:\\dic\\" . $fn . ".dic";

        open (FILE, $fn) || die "Cannot open file $fn\n";

        while (<FILE>) {
                chop;
                if ($_ eq "~fm3;�@") {
                        $_ = <FILE>;
                        chop;
                        if ($_ ne "") {
                                print "�b $fn �ɮת��� $. ��A���j���Ŧ�(~fm3;�@)����@��A�����Ŧ�A���ˬd�I\n";
                        }
                }
                if (/^~bb2;�i/) {
                        if ($last ne "") {
                                print "�b $fn �ɮת��� ".($.-1)." ��A�������e�@��A�����Ŧ�A���ˬd�I\n";
                        }
                }
                if (/t108/) {
                        if ($last ne "") {
                                print "�b $fn �ɮת��� ".($.-1)." ��A�����Y�r�e�@��A�����Ŧ�A���ˬd�I\n";
                        }
                }
                $len = length;
                if ($len > 500) {
                       print "�b $fn �ɮת��� $. ��F�� $len �Ӧr���A�i�ಣ�Ͱ��D�A���ˬd�I\n";
                }
                $last = $_;
                if (index ($_, "(  )") > 0) {
                        print "�b $fn �ɮת��� $. ��X�{���p�A�����ۨ�ӥb�Ϊť� (�ӫD�@�ӥ��Ϊť�)�A���ˬd�I\n";
                }
                if (/( |�@){5,}/) {
                        print "�b $fn �ɮת��� $. �榳�\\�h�ťաA���ˬd�I\n";
                }
                s/ //g;
                if (/^(�@)+$/) {
                        print "�b $fn �ɮת��� $. ��X�{���W�ߪ����ΪťաA���ˬd�I\n";
                }
                if (index ($_, "~bb2;�i", 1) > 0) {
                        print "�b $fn �ɮת��� $. ��X�{���[�ʪ������Ѧ� bb2;�i...�jbb1;�A���ˬd�I\n";
                }
                if (/~fk;..~fk;/) {
                        print "�b $fn �ɮת��� $. ��X�{�� ~fk;..~fk;�A���ˬd�I\n";
                }

                $found = index ($_, "��");
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
                                print "�b $fn �ɮת��� $. ��X�{�����׽u ���A���ˬd�I\n";
                        }
                        $found = index ($_, "��", $found+1);
                }

                if ((/^�](�ꭵ|�x��|����)\)/) ||        # �� + �b
                    (/^ ?\((�ꭵ|�x��|����)\)/)) {      # �b + �b
                        print "�b $fn �ɮת��� $. ��X�{���b�λP���άA���t��A���ˬd�I\n";
                }

                if ((substr($_, 0, 2) eq " (") &&       # �b��
                    (substr($_, 6, 2) eq "�^")) {       # ����
                        print "�b $fn �ɮת��� $. ��X�{���b�λP���άA���t��A���ˬd�I (strange)\n";
                }

                if ((substr($_, 0, 1) eq "(") &&        # �b��
                    (substr($_, 5, 2) eq "�^")) {       # ����
                        print "�b $fn �ɮת��� $. ��X�{���b�λP���άA���t��A���ˬd�I\n";
                }

                $tilde = 0;
                $len = length ($_);
                $offset = 0;
                while ($offset < $len) {
                        $c = ord (substr ($_, $offset));
                        if ((0x81 <= $c) && ($c <= 0xFE)) {
                                $c = ord (substr ($_, $offset+1));
                                if (((0x40 <= $c) && ($c <= 0x7E)) ||
                                    ((0xA1 <= $c) && ($c <= 0xFE))) {
                                        $offset += 2;
                                        next;
                                } else {
                                        print "�b $fn �ɮת��� $. ��� ".($offset+1)." �r�����D BIG-5 �X�d��r���A���ˬd�I\n";
                                }
                        }
                        if ($c == ord('~')) { $tilde++; }
                        if ($c == ord(';')) { $tilde--; }
                        $offset++;
                }
                if ($tilde != 0) {
                        print "�b $fn �ɮת��� $. �榳�C�L����Ÿ������ﱡ�ΡA���ˬd�I\n";
                }
                if ($offset > $len) {
                        print "�b $fn �ɮת��� $. �榳�N�~�����~���p�o�͡A���ˬd�I\n";
                }

                $fk = 0;
                $fm3 = 0;
                $offset = ($[-1);
                while (($offset = index($_, "~fk;", $offset+1)) != ($[-1)) {
                        $fk++;
                }
                $offset = ($[-1);
                while (($offset = index($_, "~fm3;", $offset+1)) != ($[-1)) {
                        $fm3++;
                }
                if (($fk != $fm3) && ($_ ne "~fm3;") && ($_ ne "~fm3;�@")) {
                        print "�b $fn �ɮת��� $. �榳 ~fk; ~fm3; �����ﱡ�ΡA���ˬd�I\n";
                }
                if (/(\?|�H){3,}/) {
                        print "�b $fn �ɮת��� $. �榳�T�ӥH�W�s��ݸ��A���ˬd�I\n";
                }
        }

        if ($last ne "") {
                print "�b $fn �ɮת��̫�@��X�{����r�A���ˬd�I\n";
        }

        close (FILE);
}

select ($oldfh);
close (OUTPUT);
