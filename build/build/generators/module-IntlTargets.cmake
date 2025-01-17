# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/module-Intl-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${libgettext_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${Intl_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET Intl::Intl)
    add_library(Intl::Intl INTERFACE IMPORTED)
    message(${Intl_MESSAGE_MODE} "Conan: Target declared 'Intl::Intl'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/module-Intl-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()