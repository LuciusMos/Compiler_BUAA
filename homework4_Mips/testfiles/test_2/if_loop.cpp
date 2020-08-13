#include <iostream>
using namespace std;
const int ca = 1;
int ga, gb;
int gc[2];
int main() {
	ga = 8;
	gb = 2;
	gc[0] = 5;
	gc[1] = 0;
	if (ga > gb) cout << ga << endl;
	else cout << "??" << endl;
	if (ga+gc[1]-ca) ga = 3;
	cout << ga << endl;
}
