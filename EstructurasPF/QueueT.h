#include "NodoT.h"
#include <iostream>

template <class T>
class QueueT
{
private:
    NodoT<T> *head;
    NodoT<T> *tail;
    int size;

public:
    QueueT()
    {
        head = nullptr;
        tail = nullptr;
        size = 0;
    }
    ~QueueT() {};
    int getsize() { return size; }
    bool isempty() { return (size == 0) ? true : false; }

    void enqueue(T dato);                // agrega al principio, addlast
    void printqueue();                   // imprime la lista
    T getData(int index);                // busca con el index el data
    int findData(T dato);                // busca con data el index
    T dequeue();                         // elimina con el index, deleteat
    void updateData(T index, T newdata); // busca el data y cambia con la nuevadata
    void updateAt(int index, T newdata); // cambia data con el index con la nuevadata
    void clear();                        // elimina la lista completa

    T front(); // busca el primero
    T back();  // busca el ultimo
};

template <class T>
void QueueT<T>::enqueue(T dato)
{
    NodoT<T> *aux = new NodoT<T>(dato);
    if (size == 0)
    {
        head = aux;
        tail = aux;
    }
    else
    {
        tail->next = aux;
        tail = aux;
    }
    size++;
}

template <class T>
void QueueT<T>::printqueue()
{
    if (size > 0)
    {
        NodoT<T> *aux = head;
        while (aux->next != nullptr)
        {
            cout << aux->data << " ";
            aux = aux->next;
        }
        cout << aux->data << " ";
    }
}

template <class T>
T QueueT<T>::getData(int index)
{
    if (index < size)
    {
        int i = 0;
        NodoT<T> *aux = head;
        while (i < index)
        {
            aux = aux->next;
            i++;
        }
        return aux->data;
    }
    else
    {
        return T();
    }
}

template <class T>
int QueueT<T>::findData(T data)
{
    if (size > 0)
    {
        int pos = 0;
        NodoT<T> *aux = head;
        while (pos < size && aux->data != data)
        {
            aux = aux->next;
            pos++;
        }
        if (aux == nullptr)
        {
            return -1;
        }
        else
        {
            return pos;
        }
    }
    else
    {
        return -1;
    }
}

template <class T>
T QueueT<T>::dequeue()
{

    T data;
    NodoT<T> *aux = head;
    data = aux->data;
    head = aux->next;
    aux = nullptr;
    delete aux;
    size--;
    return data;
}

template <class T>
void QueueT<T>::updateData(T data, T newdato)
{
    NodoT<T> *aux = head;
    int pos = 0;
    while (aux->data != data && pos < size)
    {
        aux = aux->next;
        pos++;
    }
    if (aux->data == data)
    {
        aux->data = newdato;
    }
}

template <class T>
void QueueT<T>::updateAt(int index, T newdato)
{
    if (index < size)
    {
        int i = 0;
        NodoT<T> *aux = head;
        while (i < index)
        {
            aux = aux->next;
            i++;
        }
        aux->data = newdato;
    }
}

template <class T>
void QueueT<T>::clear()
{
    NodoT<T> *aux = head;
    while (head->next != nullptr)
    {
        head = aux->next;
        aux->next = nullptr;
        delete aux;
        aux = head;
    }
    head = nullptr;
    tail = nullptr;
    size = 0;
    cout << endl
         << "Lista borrada" << endl;
}

template <class T>
T QueueT<T>::front()
{
    NodoT<T> *aux = head;
    return aux->data;
}

template <class T>
T QueueT<T>::back()
{
    NodoT<T> *aux = head;
    while (aux->next != nullptr)
    {
        aux = aux->next;
    }
    return aux->data;
}