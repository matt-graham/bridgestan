# Stan's auto-detection isn't smart enough for em++
CXX_TYPE=clang

# use our wasm-friendly TBB, not Stan's vendored version
TBB_INTERFACE_NEW=1
TBB_INC=/app/oneTBB/install/include/
TBB_LIB=/app/oneTBB/install/lib/
LDFLAGS_TBB ?= -Wl,-L,"$(TBB_LIB)"
LDLIBS_TBB ?= -ltbb

# could also uses -fexceptions which is more compatible, but slower
CXXFLAGS+=-fwasm-exceptions

LDFLAGS+=-sMODULARIZE -sEXPORT_NAME=createModule -sEXPORT_ES6 -sENVIRONMENT=web,worker -sINCOMING_MODULE_JS_API=print,printErr
LDFLAGS+=-sEXIT_RUNTIME=1 -sALLOW_MEMORY_GROWTH=1
# Functions we want. Can add more, with a prepended _, from bridgestan.h
EXPORTS=_malloc,_free,_bs_model_construct,_bs_model_destruct,_bs_free_error_msg,_bs_name,_bs_model_info,_bs_param_names,_bs_param_unc_names,_bs_param_num,_bs_param_unc_num,_bs_param_constrain,_bs_param_unconstrain,_bs_param_unconstrain_json,_bs_log_density,_bs_log_density_gradient,_bs_log_density_hessian,_bs_log_density_hessian_vector_product,_bs_rng_construct,_bs_rng_destruct,_bs_set_print_callback
LDFLAGS+=-sEXPORTED_FUNCTIONS=$(EXPORTS) -sEXPORTED_RUNTIME_METHODS=stringToUTF8,getValue,UTF8ToString,lengthBytesUTF8,HEAPF64
