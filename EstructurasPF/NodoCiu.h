#include "NodoRec.h"

template <class T>
class NodoRec;

template <class T>
class LinkedListT;
template <class T>
class LinkedListGP;
template <class T>
class LinkedListPF;
template <class T>

class NodoCiu
{
    friend class LinkedListT<T>;
    friend class LinkedListGP<T>;
    friend class LinkedListPF<T>;

private:
    NodoCiu<T> *next;
    NodoRec<T> *adj;
    T nomciudad;
    bool procesado{false};

public:
    NodoCiu(T d)
    {
        nomciudad = d;
        next = nullptr;
        adj = nullptr;
    };
};