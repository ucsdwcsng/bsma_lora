INCLUDE(FindPkgConfig)
PKG_CHECK_MODULES(PC_WCSNG_FDR_LP wcsng_fdr_lp)

FIND_PATH(
    WCSNG_FDR_LP_INCLUDE_DIRS
    NAMES wcsng_fdr_lp/api.h
    HINTS $ENV{WCSNG_FDR_LP_DIR}/include
        ${PC_WCSNG_FDR_LP_INCLUDEDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/include
          /usr/local/include
          /usr/include
)

FIND_LIBRARY(
    WCSNG_FDR_LP_LIBRARIES
    NAMES gnuradio-wcsng_fdr_lp
    HINTS $ENV{WCSNG_FDR_LP_DIR}/lib
        ${PC_WCSNG_FDR_LP_LIBDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/lib
          ${CMAKE_INSTALL_PREFIX}/lib64
          /usr/local/lib
          /usr/local/lib64
          /usr/lib
          /usr/lib64
)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(WCSNG_FDR_LP DEFAULT_MSG WCSNG_FDR_LP_LIBRARIES WCSNG_FDR_LP_INCLUDE_DIRS)
MARK_AS_ADVANCED(WCSNG_FDR_LP_LIBRARIES WCSNG_FDR_LP_INCLUDE_DIRS)

