// Test.cpp: ���������� ����� ����� ��� ����������� ����������.
//

#include "stdafx.h"

extern "C"  __declspec(dllimport) void LoadModel(wchar_t* s);
extern "C" __declspec(dllimport) void EvalModel(double* inp, double* out);

int main()
{
	wchar_t* s= L"D:\\Forex\\ForexEval\\x64\\Debug\\Models\\model.cmf";
	LoadModel(s);
	return 0;
}

