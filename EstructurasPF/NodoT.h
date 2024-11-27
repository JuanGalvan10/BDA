#ifndef NODET_H
#define NODET_H

template <class T> class LinkedListT;
template <class T> class LinkedListGP;
template <class T> class QueueT;
template <class T> class Stack;
template <class T>
    
class NodoT
{
    
    friend class LinkedListT<T>;
    friend class LinkedListGP<T>;
    friend class QueueT<T>;
    friend class Stack<T>;
    private:
     NodoT<T> *next;
     T data;
     bool procesado {false};
     int peso{0};

    public:
     NodoT(T d) {data = d; next = nullptr;}
     
    NodoT(T d, int ponderacion) {data = d; peso = ponderacion; next = nullptr;};
};

#endif

