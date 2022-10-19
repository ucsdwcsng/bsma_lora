/* -*- c++ -*- */

#define WCSNG_FDR_LP_API
#define ETTUS_API

%include "gnuradio.i"/*			*/// the common stuff

//load generated python docstrings
%include "wcsng_fdr_lp_swig_doc.i"
//Header from gr-ettus
%include "ettus/device3.h"
%include "ettus/rfnoc_block.h"
%include "ettus/rfnoc_block_impl.h"

%{
#include "ettus/device3.h"
#include "ettus/rfnoc_block_impl.h"
#include "wcsng_fdr_lp/lorapackdetect.h"
#include "wcsng_fdr_lp/lorabusytone.h"
#include "wcsng_fdr_lp/nullx.h"
#include "wcsng_fdr_lp/adder.h"
%}

%include "wcsng_fdr_lp/lorapackdetect.h"
GR_SWIG_BLOCK_MAGIC2(wcsng_fdr_lp, lorapackdetect);
%include "wcsng_fdr_lp/lorabusytone.h"
GR_SWIG_BLOCK_MAGIC2(wcsng_fdr_lp, lorabusytone);
%include "wcsng_fdr_lp/nullx.h"
GR_SWIG_BLOCK_MAGIC2(wcsng_fdr_lp, nullx);
%include "wcsng_fdr_lp/adder.h"
GR_SWIG_BLOCK_MAGIC2(wcsng_fdr_lp, adder);
