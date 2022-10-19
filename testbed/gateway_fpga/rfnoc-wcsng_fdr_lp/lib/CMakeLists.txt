# Copyright 2011,2012 Free Software Foundation, Inc.
#
# This file is part of GNU Radio
#
# GNU Radio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# GNU Radio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GNU Radio; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.

########################################################################
# Setup library
########################################################################
include(GrPlatform) #define LIB_SUFFIX

include_directories(${Boost_INCLUDE_DIR})
link_directories(${Boost_LIBRARY_DIRS})

list(APPEND wcsng_fdr_lp_sources
    lorapackdetect_impl.cc
    lorapackdetect_block_ctrl_impl.cpp
    lorabusytone_impl.cc
    lorabusytone_block_ctrl_impl.cpp
    nullx_impl.cc
    nullx_block_ctrl_impl.cpp
    adder_impl.cc
    adder_block_ctrl_impl.cpp
)


set(wcsng_fdr_lp_sources "${wcsng_fdr_lp_sources}" PARENT_SCOPE)
if(NOT wcsng_fdr_lp_sources)
	MESSAGE(STATUS "No C++ sources... skipping lib/")
	return()
endif(NOT wcsng_fdr_lp_sources)

add_library(gnuradio-wcsng_fdr_lp SHARED ${wcsng_fdr_lp_sources})
target_link_libraries(gnuradio-wcsng_fdr_lp ${Boost_LIBRARIES} ${GNURADIO_ALL_LIBRARIES} ${ETTUS_LIBRARIES})
set_target_properties(gnuradio-wcsng_fdr_lp PROPERTIES DEFINE_SYMBOL "gnuradio_wcsng_fdr_lp_EXPORTS")

if(APPLE)
    set_target_properties(gnuradio-wcsng_fdr_lp PROPERTIES
        INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib"
    )
endif(APPLE)

########################################################################
# Install built library files
########################################################################
install(TARGETS gnuradio-wcsng_fdr_lp
    LIBRARY DESTINATION lib${LIB_SUFFIX} # .so/.dylib file
    ARCHIVE DESTINATION lib${LIB_SUFFIX} # .lib file
    RUNTIME DESTINATION bin              # .dll file
)

########################################################################
# Build and register unit test
########################################################################
include(GrTest)

include_directories(${CPPUNIT_INCLUDE_DIRS})

list(APPEND test_wcsng_fdr_lp_sources
    ${CMAKE_CURRENT_SOURCE_DIR}/test_wcsng_fdr_lp.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/qa_wcsng_fdr_lp.cc
)

add_executable(test-wcsng_fdr_lp ${test_wcsng_fdr_lp_sources})

target_link_libraries(
  test-wcsng_fdr_lp
  ${GNURADIO_RUNTIME_LIBRARIES}
  ${Boost_LIBRARIES}
  ${CPPUNIT_LIBRARIES}
  ${ETTUS_LIBRARIES}
  ${PC_ETTUS_LIBDIR}
  gnuradio-wcsng_fdr_lp
)



GR_ADD_TEST(test_wcsng_fdr_lp test-wcsng_fdr_lp)
