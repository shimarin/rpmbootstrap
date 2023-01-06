all: rpmbootstrap

rpmbootstrap: rpmbootstrap.cpp
	g++ -I /usr/include/libxml2 -std=c++20 -D__USE_REAL_MAIN__ -o $@ $< -lxml2 -lcurl
