//clases y bibliotecas a usar
#include "NodoCiu.h"
#include "QueueT.h"
#include "Stack.h"
#include "Hora.h"
#include <iostream>
#include <fstream>
#include <limits>

template <class T>
class LinkedListPF
{
private:
    int table[82][5]; //iniciar tablas para los recorridos Dijkstra
    NodoCiu<T> *headCiu;
    QueueT<T> queueT;
    Stack<T> stack;
    QueueT<T> procesados;
    int size;

    int procesado(T data); // metodo para saber si ya fue procesado 

    int DijkstraRun_Carro(T from); //Dijkstra recorrdio de carro 
    int DijkstraRun_Tren(T from); //Dijkstra recorrido de tren
    void initTable(T from); //inicializar la tabla
    void printTable(); // imprimir tabla, no utilizado

public:
    LinkedListPF() : headCiu(nullptr), size(0) {}
    ~LinkedListPF() {}

    int getsize() { return size; }
    bool isempty() { return (size == 0) ? true : false; }

    // proyecto final funciones
    void addCiu(T dato); //agrega ciudad (Vertice)
    void printCiudad(ostream &os); // imprime el grafo completo, ostream para imprimir en archivos
    void addRec(T from, T to, Hora tiempotren, int distanciatren, Hora tiempocarro, int distanciacarr); //agrega las conexiones entre ciudades
    int findData(T dato); // busca con data el index

    void BFS(T data, ostream &os); // Recorrido de Anchura, ostream para imprimir en archivos
    void DFS(T data, ostream &os); // Recorrdio de Profundidad, ostream para imprimir en archivos
    void resetProcesado(); //Resetear si fueron procesados, util para utilizar BFS u DFS multiples veces.
    void clearStack(); //Limpia el Stack ^^^
    void clearprocesados(); //Limpia la Fila ^^^
    int encontrado(T data); //Buscar index de dato (tenemos finddata pero regresa el dato), necesitabamos uno de index para verificar que la ciudad exista y hacer validacion

    T getData(int index); // Busca si la ciudad existe 
    void DijkstraF(T from, T to); //DijkstraFinal junta ambos metodos (recorrido por tren y carro), para usar unicamente este en el cpp
    void RutaCorta(T from); //Busca las ruta mas cortas e imprime la ruta, distancia y su tiempo.
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
void LinkedListPF<T>::printCiudad(ostream &os)
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
                        os << aux2->data << " ";
                        os << aux2->T_tren << " ";
                        os << aux2->D_tren << " ";
                        os << aux2->T_carro << " ";
                        os << aux2->D_carro << " - ";
                        aux2 = aux2->next;
                    }
                }
                os << endl;
            }
            aux = aux->next;
        }
    }
}

// recibe todos losparametros para agregar nodosadyacentes
template <class T>
void LinkedListPF<T>::addRec(T from, T to, Hora tiempotren, int distanciatren, Hora tiempocarro, int distanciacarr)
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
            cout << "La ciudad " << to << " ya fue agregada hacia " << from << endl; // validacion si ya fue agregada
            return;
        }
        aux2 = aux2->next;
    }

    if (aux->nomciudad == from)
    {
        NodoRec<T> *aux3 = new NodoRec<T>(to, tiempotren, distanciatren, tiempocarro, distanciacarr);
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
void LinkedListPF<T>::BFS(T data, ostream &os)
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
        BFS(sigNodo, os);             // Se llama recursivamente para procesarlo
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
void LinkedListPF<T>::DFS(T data, ostream &os)
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
        if (!stack.isempty())
        {
            T sigNodo = stack.getTop();
            stack.pop();      // Eliminar el nodo procesado
            DFS(sigNodo, os); // Llamar a DFS para el siguiente nodo en el stack, recursivamente
        }
    }
}

template <class T> //limpia las ciudades con status ya procesado para reutilizarse
void LinkedListPF<T>::resetProcesado()
{
    NodoCiu<T> *aux = headCiu;
    while (aux != nullptr)
    {
        aux->procesado = false;
        NodoRec<T> *aux2 = aux->adj;
        while (aux2 != nullptr)
        {
            aux2->procesado = false;
            aux2 = aux2->next;
        }
        aux = aux->next;
    }
}

template <class T> //limpia el stack
void LinkedListPF<T>::clearStack()
{
    while (!stack.isempty())
    {
        stack.pop();
    }
}

template <class T> //limpia la fila
void LinkedListPF<T>::clearprocesados()
{
    while (!procesados.isempty())
    {
        procesados.dequeue();
    }
}

template <class T> // regresa el nombre de la ciudad
T LinkedListPF<T>::getData(int i)
{
    if (i < 0 || i >= size)
    {
        throw out_of_range("Index incorrecto");
    }
    NodoCiu<T> *aux = headCiu;
    int j = 0;
    if (i < size)
    {
        while (j < i)
        {
            j++;
            aux = aux->next;
        }
        return aux->nomciudad;
    }
}

template <class T> // busca si existe en los vertices (ciudades)
int LinkedListPF<T>::encontrado(T dato)
{
    NodoCiu<T> *aux = headCiu;

    while (aux != nullptr)
    {
        if (aux->nomciudad == dato)
        {
            return 0;
        }
        aux = aux->next;
    }
    return -1;
}

template <class T> //inicializa la tabla para Dijkstra
void LinkedListPF<T>::initTable(T from)
{
    int pos = findData(from);
    for (int i = 0; i < size; i++)
    {
        table[i][0] = i;
        table[i][1] = 0;
        table[i][2] = 0;
        table[i][3] = numeric_limits<int>::max();
        table[i][4] = -1;
    }
    table[pos][1] = 1; // una vez inicializado se pone procesado o encontrado al dato inicial por el que comienza
    table[pos][3] = 0; // se pone su costo o distancia de 0 ya que de ahi comienza
}

template <class T> //muestra la tabla de datos y el path que es 
void LinkedListPF<T>::printTable()
{
    int ruta;
    for (int i = 0; i < size; i++)
    {
        cout << table[i][0] << " ";
        cout << table[i][1] << " ";
        cout << table[i][2] << " ";
        cout << table[i][3] << " ";
        cout << table[i][4] << " ";
        if (table[i][4] == -1)
        {
            cout << table[i][0] << endl;
        }
        else
        {
            ruta = i;
            while (table[ruta][4] != -1)
            {
                cout << table[ruta][0] << " ";
                ruta = table[ruta][4];
            }
            cout << table[ruta][0] << endl;
        }
    }
}

template <class T> //Dijkstra de carro , guarda el camino mas corto desde from hacia todos los nodos
int LinkedListPF<T>::DijkstraRun_Carro(T from)
{
    int posO = findData(from);
    NodoCiu<T> *aux = headCiu;
    int pos = 0, posT, costo = table[posO][3];

    while (aux->nomciudad != from && pos < size)
    {
        aux = aux->next;
        pos++;
    }
    if (aux != nullptr && aux->nomciudad == from)
    {
        if (aux->adj != nullptr)
        {
            NodoRec<T> *aux2 = aux->adj;
            do
            {
                posT = findData(aux2->data);
                if (table[posT][1] == 0)
                {
                    if (table[posT][3] > (costo + aux2->D_carro))
                    {
                        int tiempocar = aux2->T_carro.aMin(aux2->T_carro);
                        int horaacum = table[posO][2] + tiempocar;
                        table[posT][2] = horaacum;
                        table[posT][3] = costo + aux2->D_carro;
                        table[posT][4] = posO;
                    }
                }
                aux2 = aux2->next;
            } while (aux2 != nullptr);
        }
    }
    int menor = numeric_limits<int>::max();
    int posM = -1;
    for (int i = 0; i < size; i++)
    {
        if (table[i][1] == 0)
        {
            if (table[i][3] < menor)
            {
                menor = table[i][3];
                posM = i;
            }
        }
    }
    if (menor != numeric_limits<int>::max())
    {
        from = getData(posM);
        posO = findData(from);
        table[posO][1] = 1;
        DijkstraRun_Carro(from);
    }
    else
    {
        return 0;
    }
    return 0;
}

template <class T> //Muestra la ruta mas corta e imprime su distancia y tiempo
void LinkedListPF<T>::RutaCorta(T to)
{
    int pos = findData(to);
    int ruta = pos;

    if (table[pos][3] == 0)
    {
        cout << "Es la misma ciudad de origen, el precio es 0" << endl;
    }
    bool first = true;
    while (pos != -1)
    {
        if (!first)
        {
            cout << " <- ";
        }
        cout << getData(pos);
        first = false;
        pos = table[pos][4];
    }
    cout << endl << "Distancia: " << table[ruta][3] << "km." << endl;
    int tiempoint = table[ruta][2];
    Hora horaFinal = Hora().aHora(tiempoint);
    cout << "Tiempo: " <<  horaFinal << endl;

    cout << endl;
}

template <class T> //Dijkstra de tren, guarda el camino mas corto desde from hacia todos los nodos
int LinkedListPF<T>::DijkstraRun_Tren(T from)
{
    int posO = findData(from);
    NodoCiu<T> *aux = headCiu;
    int pos = 0, posT, costo = table[posO][3];
    while (aux->nomciudad != from && pos < size)
    {
        aux = aux->next;
        pos++;
    }
    if (aux != nullptr && aux->nomciudad == from)
    {
        if (aux->adj != nullptr)
        {
            NodoRec<T> *aux2 = aux->adj;
            do
            {
                posT = findData(aux2->data);
                if (table[posT][1] == 0)
                {
                    if (table[posT][3] > (costo + aux2->D_tren))
                    {
                        int tiempocar = aux2->T_tren.aMin(aux2->T_tren);
                        int horaacum = table[posO][2] + tiempocar;
                        table[posT][3] = costo + aux2->D_tren;
                        table[posT][2] = horaacum;
                        table[posT][4] = posO;
                    }
                }
                aux2 = aux2->next;
            } while (aux2 != nullptr);
        }
    }
    int menor = numeric_limits<int>::max();
    int posM = -1;
    for (int i = 0; i < size; i++)
    {
        if (table[i][1] == 0)
        {
            if (table[i][3] < menor)
            {
                menor = table[i][3];
                posM = i;
            }
        }
    }
    if (menor != numeric_limits<int>::max())
    {
        from = getData(posM);
        posO = findData(from);
        table[posO][1] = 1;
        DijkstraRun_Tren(from);
    }
    else
    {
        return 0;
    }
    return 0;
}

/*template <class T> //DijkstrF, une todos los metodos por simplicidad, incianizandolo tomando datos de carro imprimiendoloes, inicializandolo 
de nuevo e imprimirneo el camino mas corto de tren.*/

template <class T> 
void LinkedListPF<T>::DijkstraF(T from, T to)
{
    initTable(from);
    DijkstraRun_Carro(from);
    cout << "La ruta mas corta por carro es: " << endl;
    RutaCorta(to);

    initTable(from);
    DijkstraRun_Tren(from);
    cout << "La ruta mas corta por tren es: " << endl;
    RutaCorta(to);
}
