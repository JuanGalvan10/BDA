#include "NodoT.h"
template <class T> class LinkedListT;
template <class T> class LinkedListGP;
template <class T>

    
class NodoTv
{
    friend class LinkedListT<T>;
    friend class LinkedListGP<T>;
    private:
    NodoTv<T> *next;
    NodoT<T> *adj;
    T data;
    bool procesado {false};
    int peso{0};
    

    public:
    NodoTv(T d) {data = d; next = nullptr; adj = nullptr;};
    NodoTv(T d, int ponderacion) {data = d; peso = ponderacion; next = nullptr;};
};
