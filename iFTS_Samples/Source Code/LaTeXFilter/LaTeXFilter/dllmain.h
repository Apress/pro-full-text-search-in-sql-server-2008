// dllmain.h : Declaration of module class.

class CLaTeXFilterModule : public CAtlDllModuleT< CLaTeXFilterModule >
{
public :
	DECLARE_LIBID(LIBID_LaTeXFilterLib)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_LATEXFILTER, "{C13A28F6-E2A5-48A7-8181-94139D491727}")
};

extern class CLaTeXFilterModule _AtlModule;
