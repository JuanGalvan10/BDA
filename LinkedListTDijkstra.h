//#include "QueueT.h"
// #include "StackT.h"
#include "NodeTvt.h"
#include <limits>

template <class T>
class LinkedListT{
private:
    NodeTvt<T> *head;
    int size;
    //QueueT<T> fila;
    // Stack<T> pila;
    int table[20][4];
    void initTable(T from);
    void printTable(T from);
    int DijkstraRun(T from);
public:
    LinkedListT(){
        head = nullptr;
        size = 0;   
    };
    ~LinkedListT(){};
    int getsize(){return size;};
    bool isEmpty(){return (size==0)? true : false;}
    void addFirst(T dato);
    void addLast(T dato);
    void printLists();
    T getData(int index);
    int findData(T dato);
    bool deleteData(T dato);
    bool deleteAt(int index);
    void updateData(T dato, T newDato);
    void updateAt(int index, T newDato);
    void clear();
    void printGrafo();
    void addAdj(T from, T to);
    void addAdj(T from, T to, int ponderacion);
    void BFS(T data);
    void DFS(T data);
    void Dijkstra(T from);
};

template<class T>
void LinkedListT<T>::initTable(T from){
    int pos = findData(from);
    for(int i =0; i< size; i++){
        table[i][0] = i;
        table[i][1] = 0;
        table[i][2] = numeric_limits<T>::max();
        table[i][3] = -1;
    }
    table[pos][1] = 1;
    table[pos][2] = 0;
}

template<class T>
void LinkedListT<T>::printTable(T from){
    int ruta;
    for(int i = 0; i < size; i++){
        cout << table[i][0] << " ";
        cout << table[i][1] << " ";
        cout << table[i][2] << " ";
        cout << table[i][3] << " ";
        if(table[i][3] == -1){
            cout << table[i][0]<< endl;
        }
        else{
            ruta = i;
            while(table[ruta][3]!=-1){
                cout << table[ruta][0] << " ";
                ruta = table[ruta][3];
            }
            cout << table[ruta][0] << endl;
        }
    }
}

template<class T>
void LinkedListT<T>::Dijkstra(T from){
    initTable(from);
    int res = DijkstraRun(from);
    printTable(from);
}

template<class T>
int LinkedListT<T>::DijkstraRun(T from){
    int posO = findData(from);
    NodeTvt<T> *aux = head;
    int pos=0, posT, costo = table[posO][2];
    while(aux->data != from && aux->data!= from && pos < size){
        aux = aux->next;
        pos++;
    }
    if(aux != nullptr && aux->data == from){
        if(aux->adj!=nullptr){
            NodeT<T> *aux2 = aux->adj;
            do{
                posT = findData(aux2->data);
                if(table[posT][1]==0){
                    if(table[posT][2] > (costo + aux2->peso)){
                        table[posT][2] = costo + aux2->peso;
                        table[posT][3] = posO;
                    }
                }
                aux2 = aux2->next;
            }while(aux2!=nullptr);
        }
    }
    int menor = numeric_limits<T>::max();
    int posM = -1;
    for(int i =0; i<size; i++){
        if(table[i][1]==0){
            if(table[i][2] < menor){
                menor = table[i][2];
                posM = i;
            }
        }
    }
    if(menor!=numeric_limits<T>::max()){
        from = getData(posM);
        posO=findData(from);
        table[posO][1]=1;
        DijkstraRun(from);
    }
    else{
        return 0;
    }
    return 0;
}

template<class T>
void LinkedListT<T>::BFS(T data){
    NodeTvt<T> *aux = head;
    int pos = 0;
    while(aux->data != data && pos < size){
        aux = aux->next;
        pos++;
    }
    if (aux->data == data && aux->procesado == false){
        aux->procesado = true;
        cout << aux->data << " ";
        if(aux->adj!=nullptr){
            NodeT<T> *aux2 = aux->adj;
            aux2->procesado = true;
            fila.enQueue(aux2->data);
            while(aux2->next!=nullptr){
                aux2 = aux2->next;
                aux2->procesado = true;
                fila.enQueue(aux2->data);
            }
        }
    }
    T sigNodo = fila.getData(0);
    if(!fila.isEmpty()){
        fila.deQueue();
        BFS(sigNodo);
    }
}

//pos = -1 indica que no se encontro en la fila.
template<class T>
void LinkedListT<T>::DFS(T data){
    NodeTvt<T> *aux = head;
    int pos = 0;
    while(aux->data != data && pos < size){ //Se busca la posicion del Nodo con adyacencia
        aux = aux->next;
        pos++;
    } 
    if (aux->data == data && fila.findData(aux->data) == -1){ // Se verifica que el nodo sea el buscado, y que no haya sido desplegado
        fila.enQueue(aux->data); // Se añade a una fila para saber cuales hemos desplegao
        pila.push(aux->data); // SE agrega el nodo nuevo al stack
        cout << aux->data << " "; // Se despliega el nodo
        if(aux->adj!=nullptr && fila.findData(aux->adj->data) == -1){ // Se verifica si su adyacencia no ha sido desplegada anteriormente
            DFS(aux->adj->data); // Se usa recursividad con el nodo adyacencia
        }
        else{
            if(fila.findData(aux->adj->data) != -1){ //Si su adyacencia ya ha sido desplegada, se busca otros vecinos
                NodeT<T> *aux2 = aux->adj;
                while(aux2->next!=nullptr && fila.findData(aux2->data) != -1){
                    aux2 = aux2->next;
                }
                if(fila.findData(aux2->data) == -1){ //Si algun vecino no ha sido deplegado, se aplica la recursividad con el mismo
                    DFS(aux2->data);
                }
            }
        }
    }
    // Si todos los vecinos fueron desplegados del nodo, se saca el ultimo nodo de la pila, para verificar sus vecinos.
    if(!pila.isEmpty()){ 
        pila.pop();
        if(!pila.isEmpty()){ //Se verifica que la pila no este vacia
            T data = pila.getTop();
            aux = head;
            pos = 0;
            while(aux->data != data && pos < size){ //Se busca la posicion del nodo
                aux = aux->next;
                pos++;
            }
            NodeT<T> *aux2 = aux->adj;
            while(aux2->next!=nullptr && fila.findData(aux2->data) != -1){ //Se busca el primer vecino que no haya sido desplegado
                aux2 = aux2->next;
            }
            if(fila.findData(aux2->data) == -1){ //Si al final del recorrido, el vecino no se ha desplegado, se usa recursividad.
                DFS(aux2->data);
            }
        }   
    }
}

template<class T>
void LinkedListT<T>::addAdj(T from, T to){
    NodeTvt<T> *aux = head;
    int pos = 0;
    while(aux->data != from && pos < size){
        aux = aux->next;
        pos++;
    }
    if (aux->data == from){
        NodeT<T> *aux2 = new NodeT<T>(to);
        if(aux->adj == nullptr){
            aux->adj = aux2;
        }
        else{
            NodeT<T> *aux3 = aux->adj;
            while(aux3->next != nullptr){
                aux3 = aux3->next;
            }
            aux3->next = aux2;
        }
    }

}

template<class T>
void LinkedListT<T>::addAdj(T from, T to, int ponderacion){
    NodeTvt<T> *aux = head;
    int pos = 0;
    while(aux->data != from && pos < size){
        aux = aux->next;
        pos++;
    }
    if (aux->data == from){
        NodeT<T> *aux2 = new NodeT<T>(to, ponderacion);
        if(aux->adj == nullptr){
            aux->adj = aux2;
        }
        else{
            NodeT<T> *aux3 = aux->adj;
            while(aux3->next != nullptr){
                aux3 = aux3->next;
            }
            aux3->next = aux2;
        }
    }

}

template <class T>
void LinkedListT<T>::clear(){
    NodeTvt<T> *aux = head;
    while(head->next!=nullptr){
        head = aux->next;
        aux->next = nullptr;
        delete aux;
        aux = head;
    }
    head = nullptr;
    delete head;
    size = 0;
}

template <class T>
void LinkedListT<T>::addFirst(T d){
    NodeTvt<T> *aux = new NodeTvt<T>(d);
    aux->next = head;
    head = aux;
    size++; 
}

template <class T>
void LinkedListT<T>::addLast(T d){
    NodeTvt<T> *aux = head;
    while(aux->next != nullptr){
        aux = aux->next;
    }
    aux->next = new NodeTvt<T>(d);
    size++; 
}

template <class T>
void LinkedListT<T>::printLists(){
    if(size > 0){
        NodeTvt<T> *aux = head;
        while(aux->next != nullptr){
            cout << aux->data << endl;
            aux = aux->next;
        }
        cout << aux->data << endl;
    }
}

template <class T>
void LinkedListT<T>::printGrafo(){
    if(size > 0){
        NodeTvt<T> *aux = head;
        NodeT<T> *aux2;
        while(aux->next != nullptr){
            cout << aux->data << " ";
            if(aux->adj != nullptr){
                aux2 = aux->adj;
                cout << " -"<< aux2->peso << "- ";
                cout << aux2->data << " ";
                while(aux2->next != nullptr){
                    aux2 = aux2->next;
                    cout << " -"<< aux2->peso << "- ";
                    cout << aux2->data<< " ";
                }
            }
            cout << endl;
            aux = aux->next;
        }
        cout << aux->data << " ";
        if(aux->adj != nullptr){
            aux2 = aux->adj;
            cout << " -"<< aux2->peso << "- ";
            cout << aux2->data << " ";
            while(aux2->next != nullptr){
                aux2 = aux2->next;
                cout << " -"<< aux2->peso << "- ";
                cout << aux2->data<< " ";
            }
        }
    }
    else{
        cout << "Grafo vacio" << endl;
    }
}

template <class T>
T LinkedListT<T>::getData(int i){
    if (i < 0 || i >= size) {
        throw out_of_range("Index incorrecto");
    }
    NodeTvt<T> *aux = head;
    int j=0;
    if(i < size){
        while(j < i){
            j++;
            aux = aux->next;
        }
    return aux->data;
    }
}

template <class T>
int LinkedListT<T>::findData(T data){
    NodeTvt<T> *aux = head;
    int pos = 0;
    while(aux!=nullptr && aux->data != data){
        aux = aux->next;
        pos++;
    }
    return pos;
}

template <class T>
bool LinkedListT<T>::deleteData(T data){
    bool borrado = false;
    NodeTvt<T> *aux2, *aux = head;
    while(aux->next != nullptr && aux->data!= data){
        aux2 = aux;
        aux = aux->next;
    }
    if(aux->data == data){
        aux2->next = aux->next;
        aux->next = nullptr;
        delete aux;
        borrado = true;
        size --;
    }
    return borrado;
}

template <class T>
bool LinkedListT<T>::deleteAt(int i){
    int pos=0;
    bool borrado = false;
    NodeTvt<T> *aux2, *aux = head;
    while(pos!=i && aux->next != nullptr){
        aux2 = aux;
        aux = aux->next;
        pos++;
    }
    if(pos == i){
        aux2->next = aux->next;
        aux->next = nullptr;
        delete aux;
        borrado = true;
        size --;
    }
    return borrado;
}

template <class T>
void LinkedListT<T>::updateData(T data, T newDato){
    NodeTvt<T> *aux = head;
    while(aux->next!= nullptr && aux->data != data){
        aux = aux->next;
    }
    if(aux->data == data){
        aux->data = newDato;
    }
}

template <class T>
void LinkedListT<T>::updateAt(int i, T newDato){
    int pos =0;
    NodeTvt<T> *aux = head;
    bool actualziado = false;
    while(aux->next!= nullptr && pos != i){
        aux = aux->next;
        pos++;
    }
    if(pos == i){
        aux->data = newDato;
    }
}
