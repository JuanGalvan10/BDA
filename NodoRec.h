#ifndef NODEREC_H
#define NODEREC_H

template <class T>class LinkedListT;
template <class T>class LinkedListGP;
template <class T>class LinkedListPF;
template <class T>class QueueT;
template <class T>class Stack;
template <class T>

class NodoRec
{

    friend class LinkedListT<T>;
    friend class LinkedListGP<T>;
    friend class LinkedListPF<T>;
    friend class QueueT<T>;
    friend class Stack<T>;

private:
    NodoRec<T> *next;
    T data;
    bool procesado{false};
    T T_tren; 
    int D_tren; 
    T T_carro;   
    int D_carro;

public:
    NodoRec(T d)
    {
        data = d;
        next = nullptr;
        T_tren = T();
        D_tren = 0;
        T_carro = T();
        D_carro = 0;
    }

    NodoRec(T d, T Time_tren, int Dis_tren, T Time_carro, int Dis_carro)
    {
        data = d;
        T_tren = Time_tren;
        D_tren = Dis_tren;
        T_carro = Time_carro;
        D_carro = Dis_carro;
        next = nullptr;
    };
};

#endif