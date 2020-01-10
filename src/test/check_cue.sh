#!/bin/sh
# Tests to see that BIN/CUE and cdrdao TOC file iamge reading is correct
# (via cd-info).

if test ! -d "" ; then
  vcd_opt='--no-vcd'
fi

if test ! -d "$abs_top_srcdir" ; then
  abs_top_srcdir=/src/external-vcs/savannah/libcdio
fi

if test ! -d "$top_builddir" ; then
  top_builddir=/src/external-vcs/savannah/libcdio
fi

. ${top_builddir}/test/check_common_fn

CD_INFO=$abs_top_srcdir/src/cd-info
if test ! -x $CD_INFO ; then
  exit 77
fi

BASE=`basename $0 .sh`

fname=cdda
testnum=CD-DA
if test -f ${abs_top_srcdir}/test/data/${fname}.bin ; then
  opts="--quiet --no-device-info --cue-file ${abs_top_srcdir}/test/data/${fname}.cue --no-cddb"
  test_cdinfo "$opts" ${fname}.dump ${abs_top_srcdir}/test/${fname}.right
  RC=$?
  check_result $RC "cd-info CUE test $testnum" "${CD_INFO} $opts"

  opts="--quiet --no-device-info --bin-file ${abs_top_srcdir}/test/data/${fname}.bin --no-cddb"
  test_cdinfo "$opts" ${fname}.dump ${abs_top_srcdir}/test/${fname}.right
  RC=$?
  check_result $RC "cd-info BIN test $testnum" "${CD_INFO} $opts"
else
  echo "-- Don't see BIN file ${abs_top_srcdir}/test/data/${fname}.bin. Test $testnum skipped."
fi


fname=cdtext
testnum="CD-Text binary parser"
if test -f ${abs_top_srcdir}/test/data/${fname}.bin ; then
  if test -f ${abs_top_srcdir}/test/data/${fname}.cdt ; then
    opts="--quiet --no-device-info --cue-file ${abs_top_srcdir}/test/data/${fname}.cue --no-cddb"
    test_cdinfo "$opts" ${fname}.dump ${abs_top_srcdir}/test/${fname}.right
    RC=$?
    check_result $RC "cd-info CD-Text CUE test $testnum" "${CD_INFO} $opts"
  else
    echo "-- Don't see CD-Text file ${abs_top_srcdir}/test/data/${fname}.cdt. Test $testnum skipped."
  fi
else
  echo "-- Don't see BIN file ${abs_top_srcdir}/test/data/${fname}.bin. Test $testnum skipped."
fi


fname=isofs-m1
if test -f  ${abs_top_srcdir}/test/data/${fname}.bin ; then
  testnum='ISO 9660 mode1 CUE'
  if test -n "1"; then
    opts="-q --no-device-info --no-disc-mode --cue-file ${abs_top_srcdir}/test/data/${fname}.cue --iso9660"
    ( cd ${abs_top_srcdir}/test/
      test_cdinfo "$opts" ${fname}.dump ${fname}.right
      RC=$?
      check_result $RC "cd-info Rock-Ridge CUE test $testnum" "${CD_INFO} $opts"
    )
  else
    opts="-q --no-device-info --no-disc-mode --no-rock-ridge --cue-file ${abs_top_srcdir}/test/data/${fname}.cue --iso9660"
    ( cd ${abs_top_srcdir}/test/
      test_cdinfo "$opts" ${fname}.dump ${fname}-no-rr.right
      RC=$?
      check_result $RC "cd-info no Rock-Ridge CUE test $testnum" "${CD_INFO} $opts"
    )
  fi

  testnum='ISO 9660 mode1 TOC'
  if test -n "1"; then
    opts="-q --no-device-info --no-disc-mode --toc-file ${abs_top_srcdir}/test/data/${fname}.toc --iso9660"
    ( cd ${abs_top_srcdir}/test/
      test_cdinfo "$opts" ${fname}.dump ${fname}-test2.right
      RC=$?
      check_result $RC "cd-info TOC test $testnum" "${CD_INFO} $opts"
    )
  fi
else
  echo "-- Don't see BIN file ${abs_top_srcdir}/test/data/${fname}.bin. Test $testnum skipped."
fi


fname=vcd_demo
testnum='Video CD'
if test -f ${abs_top_srcdir}/test/data/${fname}.bin ; then
  if test -z "" ; then
    right=${abs_top_srcdir}/test/${fname}.right
  else
    right=${abs_top_srcdir}/test/${fname}_vcdinfo.right
  fi

  opts="-q --no-device-info --no-disc-mode -c ${abs_top_srcdir}/test/data/${fname}.cue --iso9660"
  test_cdinfo "$opts" ${fname}.dump $right
  RC=$?
  check_result $RC "cd-info CUE test $testnum" "${CD_INFO} $opts"

  opts="-q --no-device-info --no-disc-mode -t ${abs_top_srcdir}/test/data/${fname}.toc --iso9660"
  test_cdinfo "$opts" ${fname}.dump $right
  RC=$?
  check_result $RC "cd-info TOC test $testnum" "${CD_INFO} $opts"
else
  echo "-- Don't see BIN file ${abs_top_srcdir}/test/data/${fname}.bin. Test $testnum skipped."
fi

fname=svcd_ogt_test_ntsc
testnum='Super Video CD'
if test -f ${abs_top_srcdir}/test/data/${fname}.bin ; then
  opts="-q --no-device-info --no-disc-mode --cue-file ${abs_top_srcdir}/test/data/${fname}.cue $vcd_opt --iso9660"
  test_cdinfo "$opts" ${fname}.dump ${abs_top_srcdir}/test/${fname}.right
  RC=$?
  check_result $RC "cd-info CUE test $testnum" "${CD_INFO} $opts"
else
  echo "-- Don't see BIN file ${abs_top_srcdir}/test/data/${fname}.bin. Test $testnum skipped."
fi

exit $RC

#;;; Local Variables: ***
#;;; mode:shell-script ***
#;;; eval: (sh-set-shell "bash") ***
#;;; End: ***
