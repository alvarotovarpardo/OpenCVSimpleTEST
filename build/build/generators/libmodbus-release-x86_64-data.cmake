########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(libmodbus_COMPONENT_NAMES "")
if(DEFINED libmodbus_FIND_DEPENDENCY_NAMES)
  list(APPEND libmodbus_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES libmodbus_FIND_DEPENDENCY_NAMES)
else()
  set(libmodbus_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(libmodbus_PACKAGE_FOLDER_RELEASE "C:/Users/ÁlvaroTovarPardo/.conan2/p/libmoe5adc1edf5c3d/p")
set(libmodbus_BUILD_MODULES_PATHS_RELEASE )


set(libmodbus_INCLUDE_DIRS_RELEASE "${libmodbus_PACKAGE_FOLDER_RELEASE}/include"
			"${libmodbus_PACKAGE_FOLDER_RELEASE}/include/modbus")
set(libmodbus_RES_DIRS_RELEASE )
set(libmodbus_DEFINITIONS_RELEASE )
set(libmodbus_SHARED_LINK_FLAGS_RELEASE )
set(libmodbus_EXE_LINK_FLAGS_RELEASE )
set(libmodbus_OBJECTS_RELEASE )
set(libmodbus_COMPILE_DEFINITIONS_RELEASE )
set(libmodbus_COMPILE_OPTIONS_C_RELEASE )
set(libmodbus_COMPILE_OPTIONS_CXX_RELEASE )
set(libmodbus_LIB_DIRS_RELEASE "${libmodbus_PACKAGE_FOLDER_RELEASE}/lib")
set(libmodbus_BIN_DIRS_RELEASE )
set(libmodbus_LIBRARY_TYPE_RELEASE STATIC)
set(libmodbus_IS_HOST_WINDOWS_RELEASE 1)
set(libmodbus_LIBS_RELEASE modbus)
set(libmodbus_SYSTEM_LIBS_RELEASE ws2_32 wsock32)
set(libmodbus_FRAMEWORK_DIRS_RELEASE )
set(libmodbus_FRAMEWORKS_RELEASE )
set(libmodbus_BUILD_DIRS_RELEASE )
set(libmodbus_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(libmodbus_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${libmodbus_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${libmodbus_COMPILE_OPTIONS_C_RELEASE}>")
set(libmodbus_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${libmodbus_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${libmodbus_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${libmodbus_EXE_LINK_FLAGS_RELEASE}>")


set(libmodbus_COMPONENTS_RELEASE )