#include "NodeTvt.h"
#include <limits>

template <class T>
class LinkedListT{
private:
    NodeTvt<T> *head;
    int size;
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
