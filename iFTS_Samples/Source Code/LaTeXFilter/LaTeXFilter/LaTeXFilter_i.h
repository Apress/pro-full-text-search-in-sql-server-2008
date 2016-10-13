

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 7.00.0500 */
/* at Tue Jul 08 23:07:27 2008
 */
/* Compiler settings for .\LaTeXFilter.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext, robust
    error checks: stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#pragma warning( disable: 4049 )  /* more than 64k source lines */


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __LaTeXFilter_i_h__
#define __LaTeXFilter_i_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __ILaTeXFilter_FWD_DEFINED__
#define __ILaTeXFilter_FWD_DEFINED__
typedef interface ILaTeXFilter ILaTeXFilter;
#endif 	/* __ILaTeXFilter_FWD_DEFINED__ */


#ifndef __LaTeXFilter_FWD_DEFINED__
#define __LaTeXFilter_FWD_DEFINED__

#ifdef __cplusplus
typedef class LaTeXFilter LaTeXFilter;
#else
typedef struct LaTeXFilter LaTeXFilter;
#endif /* __cplusplus */

#endif 	/* __LaTeXFilter_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __ILaTeXFilter_INTERFACE_DEFINED__
#define __ILaTeXFilter_INTERFACE_DEFINED__

/* interface ILaTeXFilter */
/* [unique][helpstring][nonextensible][dual][uuid][object] */ 


EXTERN_C const IID IID_ILaTeXFilter;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("FBA051CC-2423-4C2B-A6F9-14E4D6AA55EC")
    ILaTeXFilter : public IDispatch
    {
    public:
    };
    
#else 	/* C style interface */

    typedef struct ILaTeXFilterVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ILaTeXFilter * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ILaTeXFilter * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ILaTeXFilter * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            ILaTeXFilter * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            ILaTeXFilter * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            ILaTeXFilter * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            ILaTeXFilter * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS *pDispParams,
            /* [out] */ VARIANT *pVarResult,
            /* [out] */ EXCEPINFO *pExcepInfo,
            /* [out] */ UINT *puArgErr);
        
        END_INTERFACE
    } ILaTeXFilterVtbl;

    interface ILaTeXFilter
    {
        CONST_VTBL struct ILaTeXFilterVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ILaTeXFilter_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ILaTeXFilter_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ILaTeXFilter_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ILaTeXFilter_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define ILaTeXFilter_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define ILaTeXFilter_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define ILaTeXFilter_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __ILaTeXFilter_INTERFACE_DEFINED__ */



#ifndef __LaTeXFilterLib_LIBRARY_DEFINED__
#define __LaTeXFilterLib_LIBRARY_DEFINED__

/* library LaTeXFilterLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_LaTeXFilterLib;

EXTERN_C const CLSID CLSID_LaTeXFilter;

#ifdef __cplusplus

class DECLSPEC_UUID("C87538CE-96C2-4B92-B67C-35850505E57C")
LaTeXFilter;
#endif
#endif /* __LaTeXFilterLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


