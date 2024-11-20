#include "NodoTv.h"
#include "NodoCiu.h"
#include "QueueT.h"
#include "Stack.h"
#include <iostream>
#include <fstream>

template <class T>
class LinkedListPF
{
private:
    NodoCiu<T> *headCiu;
    QueueT<T> queueT;
    Stack<T> stack;
    QueueT<T> procesados;
    int size;

    int procesado(T data);
    int DijsktraRun(T from);

public:
    LinkedListPF() : headCiu(nullptr), size(0) {}
    ~LinkedListPF() {}

    int getsize() { return size; }
    bool isempty() { return (size == 0) ? true : false; }
    // proyecto final funciones
    void addCiu(T dato);
    void printCiudad(ostream& os);
    void addRec(T from, T to, int distanciatren, int distanciacarr);
    int findData(T dato); // busca con data el index

    void BFS(T data,ostream& os);
    void DFS(T data,ostream& os);
    void resetProcesado();
    void clearStack();
    void clearprocesados();

    void Dijsktra(T from);
};

template <class T>
int LinkedListPF<T>::findData(T data)
{
    NodoCiu<T> *aux = headCiu;
    int pos = 0;
    while (aux != nullptr)
    {
        if (data == aux->nomciudad)
        {
            return pos;
        }
        aux = aux->next;
        pos++;
    }
    return -1;
}

template <class T>
void LinkedListPF<T>::addCiu(T dato)
{
    if (headCiu == nullptr)
    {
        headCiu = new NodoCiu<T>(dato);
    }
    else
    {
        NodoCiu<T> *aux = headCiu;
        while (aux->next != nullptr)
        {
            aux = aux->next;
        }
        aux->next = new NodoCiu<T>(dato);
    }
    size++;
}

template <class T>
void LinkedListPF<T>::printCiudad(ostream& os)
{
    if (size > 0)
    {
        NodoCiu<T> *aux = headCiu;
        NodoRec<T> *aux2;
        while (aux != nullptr)
        {
            bool ciudadimpreso = false;

            NodoCiu<T> *auxChecar = headCiu;
            while (auxChecar != aux)
            {
                if (auxChecar->nomciudad == aux->nomciudad)
                {
                    ciudadimpreso = true;
                    break;
                }
                auxChecar = auxChecar->next;
            }

            if (!ciudadimpreso)
            {

                os << aux->nomciudad << ": ";
                if (aux->adj != nullptr)
                {
                    aux2 = aux->adj;
                    while (aux2 != nullptr)
                    {
                        os << aux2->data << " - ";
                        aux2 = aux2->next;
                    }
                }
                os << endl;
            }
            aux = aux->next;
        }
    }
}

template <class T>
void LinkedListPF<T>::addRec(T from, T to, int distanciatren, int distanciacarr)
{
    NodoCiu<T> *aux = headCiu;
    int pos = 0;

    while (aux != nullptr && aux->nomciudad != from)
    {
        aux = aux->next;
        pos++;
    }

    NodoRec<T> *aux2 = aux->adj;
    while (aux2 != nullptr)
    {
        if (aux2->data == to)
        {
            cout << "La ciudad " << to << " ya fue agregada hacia " << from << endl;
            return;
        }
        aux2 = aux2->next;
    }

    if (aux->nomciudad == from)
    {

        NodoRec<T> *aux3 = new NodoRec<T>(to, T(), distanciatren, T(), distanciacarr);
        NodoRec<T> *aux4;
        if (aux->adj == nullptr)
        {
            aux->adj = aux3;
        }
        else
        {
            aux4 = aux->adj;
            while (aux4->next != nullptr)
            {
                aux4 = aux4->next;
            }
            aux4->next = aux3;
        }
    }
}

template <class T>
void LinkedListPF<T>::BFS(T data, ostream& os)
{
    NodoCiu<T> *aux = headCiu;

    int pos = 0;
    while (aux != nullptr && aux->nomciudad != data && pos < size)
    {
        aux = aux->next;
        pos++;
    }

    if (aux != nullptr && aux->nomciudad == data && aux->procesado == false)
    {
        aux->procesado = true;
        os << aux->nomciudad << " ";
        if (aux->adj != nullptr) // si tiene adjacencias
        {
            NodoRec<T> *aux2 = aux->adj;
            aux2->procesado = true;
            queueT.enqueue(aux2->data);
            while (aux2->next != nullptr)
            { // mientras tenga adyancencias meto a la fila
                aux2 = aux2->next;
                aux2->procesado = true;
                queueT.enqueue(aux2->data);
            }
        }
    }
    if (!queueT.isempty())
    {
        T sigNodo = queueT.dequeue(); // Se extrae el siguiente nodo de la cola
        BFS(sigNodo, os);                 // Se llama recursivamente para procesarlo
    }
}

template <class T>
int LinkedListPF<T>::procesado(T data)
{
    int pos = procesados.findData(data);

    if (pos != -1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}


template <class T>
void LinkedListPF<T>::DFS(T data,ostream& os)
{
    NodoCiu<T> *aux = headCiu;

    int pos = 0;
    while (aux->nomciudad != data && pos < size)
    {
        aux = aux->next;
        pos++;
    }
    int is = procesado(data);
    if (is == 0)
    {
        if (aux->nomciudad == data) // lo encuentra , aux tiene el dato
        {
            aux->procesado = true;
            procesados.enqueue(aux->nomciudad); // lo guarda en la fila para saber si estan procesados
            os << aux->nomciudad << " ";
            stack.push(aux->nomciudad); // lo guarda en el stack para ver el orden que sigue cuando regrese

            if (aux->adj != nullptr) // continua con sus procesados
            {

                NodoRec<T> *aux2 = aux->adj; // va con sus conectados, aux2 toma el siguiente nodo

                do
                {
                    aux2->procesado = true;
                    is = procesado(aux2->data);
                    if (is == 0)
                    {
                        DFS(aux2->data, os);
                    }
                    aux2 = aux2->next;
                } while (aux2 != nullptr);
            }
        }
        if (!stack.isempty()) {
            T sigNodo = stack.getTop();
            stack.pop();  // Eliminar el nodo procesado
            DFS(sigNodo, os);  // Llamar a DFS para el siguiente nodo en el stack
        }
    }
}

template <class T>
void LinkedListPF<T>::resetProcesado() {
    NodoCiu<T> *aux = headCiu;
    while (aux != nullptr) {
        aux->procesado = false;
        NodoRec<T> *aux2 = aux->adj;
        while (aux2 != nullptr) {
            aux2->procesado = false;
            aux2 = aux2->next;
        }
        aux = aux->next;
    }
}

template <class T>
void LinkedListPF<T>::clearStack() {
    while (!stack.isempty()) {
        stack.pop();
    }
}

template <class T>
void LinkedListPF<T>::clearprocesados() {
    while (!procesados.isempty()) {
        procesados.dequeue();
    }
}