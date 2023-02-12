packageName=$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM
outdir=$PREFIX/share/$packageName

echo "### BUILD ENV INFO"
echo "PREFIX=$PREFIX"
echo "CONDA_PREFIX=$CONDA_PREFIX"
echo "LD_RUN_PATH=$LD_RUN_PATH"
echo "ARCH = $ARCH"
echo "OSX_ARCH = $OSX_ARCH"
echo "packageName=$packageName"
echo "outdir=$outdir"
echo "siriusDistName=$siriusDistName"
echo "### BUILD ENV INFO END"

echo "### Show Build dir"
ls -lah ./


if [ -n "$OSX_ARCH" ]; then
  echo "### Run gradle build for platform: 'mac-$OSX_ARCH'"
  ./gradlew :sirius_dist:sirius_gui_multi_os:installSiriusDist \
    -P "build.sirius.location.lib=\$CONDA_PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM/lib" \
    -P "build.sirius.starter.jdk.include=false" \
    -P "build.sirius.native.cbc.exclude=true" \
    -P "build.sirius.native.openjfx.exclude=false" \
    -P "build.sirius.platform=mac-$OSX_ARCH"
else
  echo "### Run gradle build for autodetected platform"
  ./gradlew :sirius_dist:sirius_gui_multi_os:installSiriusDist \
    -P "build.sirius.location.lib=\$CONDA_PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM/lib" \
    -P "build.sirius.starter.jdk.include=false" \
    -P "build.sirius.native.cbc.exclude=true" \
    -P "build.sirius.native.openjfx.exclude=false"
fi

echo "### Create package dirs"
mkdir -p "${outdir:?}"
mkdir -p "${PREFIX:?}/bin"

echo "### Copy jars"
cp -rp ./sirius_dist/sirius_gui_multi_os/build/install/$siriusDistName/* "${outdir:?}/"
rm -r "${outdir:?}/bin"

echo "### Show jar dir"
ls -lah "$outdir/lib"

echo "### Copy starters"
cp -rp ./sirius_dist/sirius_gui_multi_os/build/install/$siriusDistName/bin/* "${PREFIX:?}/bin/"

echo "### Show bin dir"
ls -lah "$PREFIX/bin"

echo "### Show start script"
ls -lah "$PREFIX/bin/sirius"
cat "$PREFIX/bin/sirius"
