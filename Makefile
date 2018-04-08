.PHONY: default

default: libsourcey/build/webrtc/samples/webrtcrecorder/webrtcrecorderd

libsourcey/build/webrtc/samples/webrtcrecorder/webrtcrecorderd: libsourcey/build/Makefile
	cd libsourcey/build && make VERBOSE=1 webrtcrecorder

web: libsourcey/src/webrtc/samples/webrtcrecorder/client/~node_modules.done
	which nodenv
	cd libsourcey/src/webrtc/samples/webrtcrecorder/client && node app

libsourcey/src/webrtc/samples/webrtcrecorder/client/~node_modules.done: libsourcey/src/webrtc/samples/webrtcrecorder/client/package.json libsourcey/src/webrtc/samples/webrtcrecorder/client/package-lock.json
	which nodenv
	cd libsourcey/src/webrtc/samples/webrtcrecorder/client && npm install
	touch $@

rec: libsourcey/build/webrtc/samples/webrtcrecorder/webrtcrecorderd
	cd libsourcey/build/webrtc/samples/webrtcrecorder && ./webrtcrecorderd

# SEE MD COMMENT!!! https://raw.githubusercontent.com/sourcey/libsourcey/d157a149d935bdd9e10ccd307eec8a47cdd0de59/doc/installation-linux.md
# https://github.com/sourcey/sourcey.com/blob/44dd301c6fbd243bb5af89b5a5bd711083dba18d/source/2017-09-01-building-and-installing-webrtc-on-windows.md
# https://github.com/sourcey/webrtc-builds/blob/10f78e1d58b8be0085374c66060c1bb0df61d3d6/util.sh
libwebrtc/src/out/Debug/obj/default.stamp libwebrtc/src/out/Release/obj/default.stamp: 
	cd libwebrtc && \
		gclient sync && \
		cd src && \
		gn gen out/Debug --args='is_debug=true rtc_include_tests=false use_rtti=true enable_iterator_debugging=false is_component_build=false is_clang=false use_sysroot=false linux_use_bundled_binutils=false use_custom_libcxx=false use_custom_libcxx_for_host=false treat_warnings_as_errors=false' && \
		gn gen out/Release --args='is_debug=false rtc_include_tests=false use_rtti=true enable_iterator_debugging=false is_component_build=false is_clang=false use_sysroot=false linux_use_bundled_binutils=false use_custom_libcxx=false use_custom_libcxx_for_host=false treat_warnings_as_errors=false' && \
		ninja -C out/Debug && \
		ninja -C out/Release

libsourcey/build/Makefile: libwebrtc/src/out/Debug/obj/default.stamp libwebrtc/src/out/Release/obj/default.stamp
	mkdir -p libsourcey/build
	cd libsourcey/build && \
		cmake .. \
			-DWEBRTC_ROOT_DIR=$(CURDIR)/libwebrtc/src \
			-DCMAKE_BUILD_TYPE=DEBUG \
			-DBUILD_SHARED_LIBS=OFF \
			-DBUILD_APPLICATIONS=OFF \
			-DBUILD_SAMPLES_webrtc=ON \
			-DWITH_WEBRTC=ON \
			-DWITH_FFMPEG=ON \
			-DBUILD_MODULE_webrtc=ON \
			-G "Unix Makefiles"
