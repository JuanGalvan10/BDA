#include <exception>
#include "NodoT.h"
#include <iostream>

template <class T>
class Stack
{
private:
    NodoT<T> *top;
    int size;

public:
    Stack()
    {
        top = nullptr;
        size = 0;
    }
    ~Stack() {};

    int getsize() { return size; }
    bool isempty() { return (size == 0) ? true : false; }

    void push(T dato);    // agrega al principio, addfirst
    void print();         // imprime la lista
    T getTop();           // busca con el index el data, getdata
    int findData(T dato); // busca con data el index
    bool pop();           // elimina cel ultimo insertado, deleteat
    void clear();         // elimina la lista completa
};

template <class T>
void Stack<T>::push(T dato)
{
    NodoT<T> *aux = new NodoT<T>(dato);
    aux->next = top;
    top = aux;
    size++;
}

template <class T>
void Stack<T>::print()
{
    if (size > 0)
    {
        NodoT<T> *aux = top;
        while (aux->next != nullptr)
        {
            cout << aux->data << " ";
            aux = aux->next;
        }
        cout << aux->data << " ";
    }
}

template <class T>
T Stack<T>::getTop()
{
    if (size > 0)
    {
        return top->data;
    }
    else
    {
        cout << "ERROR: Pila vacía, retornando valor por defecto." << endl;
        return T(); 
    }
}

template <class T>
int Stack<T>::findData(T data)
{
    NodoT<T> *aux = top;
    int pos = 0;
    while (aux != nullptr)
    {
        if (data == aux->data)
        {
            return pos;
        }
        aux = aux->next;
        pos++;
    }
    return -1;
}

template <class T>
bool Stack<T>::pop()
{
    if (size > 0)
    {
        NodoT<T> *aux = top;
        top = aux->next;
        aux->next = nullptr;
        delete aux;
        size--;
        return true;
    }
    else
    {
        return false;
    }
}

template <class T>
void Stack<T>::clear()
{
    NodoT<T> *aux = top;
    while (top->next != nullptr)
    {
        top = aux->next;
        aux->next = nullptr;
        delete aux;
        aux = top;
    }
    delete top;
    size = 0;
    cout << endl
         << "Lista borrada" << endl;
}