WORKSPACE_DIR=`pwd`
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$WORKSPACE_DIR/depot_tools:$PATH
echo "export PATH=$WORKSPACE_DIR/depot_tools:\$PATH" >> ~/.bash_profile
gclient
mkdir $WORKSPACE_DIR/v8
cd $WORKSPACE_DIR/v8
echo "mac-arm64" > .cipd_client_platform
export VPYTHON_BYPASS="manually managed python not supported by chrome operations"
echo "export VPYTHON_BYPASS=\"manually managed python not supported by chrome operations\"" >> ~/.bash_profile
fetch v8
mkdir -p out.gn/arm64.release/
cat >> out.gn/arm64.release/args.gn <<EOF

dcheck_always_on = false
is_debug = false
target_cpu = "arm64"
v8_target_cpu = "arm64"

cc_wrapper="ccache"

is_component_build = false
is_debug = false
use_custom_libcxx = false
v8_monolithic = true
v8_use_external_startup_data = false
symbol_level = 0
v8_enable_i18n_support= false
v8_enable_pointer_compression = false

EOF

gn gen out.gn/arm64.debug


export CCACHE_CPP2=yes
export CCACHE_SLOPPINESS=time_macros

# Optionally, add this to your ~/.zshrc if you are using zsh, or any
# other equivalents
echo "export CCACHE_CPP2=yes" >> ~/.bash_profile
echo "export CCACHE_SLOPPINESS=time_macros" >> ~/.bash_profile

PATH=`pwd`/third_party/llvm-build/Release+Asserts/bin:$PATH ninja -C out.gn/arm64.release
python2 tools/run-tests.py --outdir=out.gn/arm64.release --quickcheck
