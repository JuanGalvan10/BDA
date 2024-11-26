#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
using namespace std;

#include "LinkedListProyF.h"
#include "Hora.h"

int main()
{
    //declaracion de archivos para importar y exportar
    ifstream ArchEntrada;
    ArchEntrada.open("EuropeCities.csv");
    ofstream ArchSalida1("output-1.out");
    ofstream ArchSalida2("output-2.out");
    ofstream ArchSalida3("output-3.out");

    //declaracion de variables
    string arrdatos[250][6];
    string datos, linea, ciudadA, ciudadB, DxTrain_s, DxCar_s, TxTrain_s, TxCar_s;
    string ciudad2, ciudadi, ciudadf;
    int DxTrain, DxCar;
    int cont = 0;
    int ans = 0;
    bool encontrado = false;
    LinkedListPF<string> MiCiudad;

    if (!ArchEntrada)
    {
        cout << "no se pudo abrir el archivo" << endl;
    }
    else
    {
        while (getline(ArchEntrada, linea))
        {
            //Leer los valores de todo el archivo
            stringstream datos(linea);
            getline(datos, ciudadA, ',');
            getline(datos, ciudadB, ',');
            getline(datos, TxTrain_s, ',');
            getline(datos, DxTrain_s, ',');
            getline(datos, TxCar_s, ',');
            getline(datos, DxCar_s);

            DxTrain = stoi(DxTrain_s); // convertir distancia string a entero
            DxCar = stoi(DxCar_s);     // convertir distancia string a entero

            Hora TxTrain(TxTrain_s); //convierte de string a tipo Hora 
            Hora TxCar(TxCar_s);   //convierte de string a tipo Hora

            // Busca si ya fue agergada anteriormente
            if (MiCiudad.findData(ciudadA) == -1)
            {
                MiCiudad.addCiu(ciudadA);
            }
            if (MiCiudad.findData(ciudadB) == -1)
            {
                MiCiudad.addCiu(ciudadB);
            }

            // guarda los arcos con su ponderacion bidireccion
            MiCiudad.addRec(ciudadA, ciudadB, TxTrain, DxTrain, TxCar, DxCar);

            cont++;
        }
        ArchEntrada.close();
    }

    do
    {
        cout << "       ----- MENU -----        " << endl;
        cout << "1- Desplegar Ciudad " << endl;
        cout << "2- Desplegar recorrido por medio de una ciudad " << endl;
        cout << "3- Ruta mas corta" << endl;
        cout << "4- Salir" << endl;
        cin >> ans;

        switch (ans)
        {
        case 1:
            if (ArchSalida1)
            {
                MiCiudad.printCiudad(ArchSalida1);
                cout << "Proceso Completado" << endl;
            }
            else
            {
                cout << "Error al imprimir" << endl;
            }
            break;
        case 2:
            cout << "Dame una ciudad:" << endl;
            cin.ignore();
            getline(cin, ciudad2);

            if (MiCiudad.findData(ciudad2) >= 0)
            {
                if (ArchSalida2 && ArchSalida3)
                {

                    ArchSalida2 << "-- BFS: Iniciando en " << ciudad2 << endl;
                    MiCiudad.BFS(ciudad2, ArchSalida2);
                    ArchSalida2 << endl;
                    MiCiudad.resetProcesado(); // Resetear valores de procesado despues de hacerlo una vez, no se hace en la clase ya que es recursiva.
                    ArchSalida3 << "-- DFS: Iniciando en " << ciudad2 << endl;
                    MiCiudad.DFS(ciudad2, ArchSalida3);
                    ArchSalida3 << endl;
                    MiCiudad.resetProcesado();
                    MiCiudad.clearStack();
                    MiCiudad.clearprocesados();
                    cout << "Proceso Completado" << endl;
                }
                else
                {
                    cout << "Error al imprimir" << endl;
                }
            }
            else
            {
                cout << "No se encontro esta ciudad" << endl;
            }

            break;
        case 3:
            do
            {
                cout << "Ciudad inicio: ";
                cin.ignore();
                getline(cin, ciudadi);
                cout << "Ciudad final: ";
                getline(cin, ciudadf);
                if (MiCiudad.encontrado(ciudadi) >= 0 && MiCiudad.encontrado(ciudadf) >= 0)
                {
                    encontrado = true;
                    cout << "De " << ciudadi << " a " << ciudadf << " : " << endl;
                    MiCiudad.DijkstraF(ciudadi, ciudadf);
                }
                else
                {
                    cout << "Esa ciudad no fue encontrada intente de nuevo." << endl;
                }
                
            }while (!encontrado);

            break;
        default:
            break;
        }

    } while (ans > 0 && ans < 4);
    
    //cerrar archivos utilizados
    ArchSalida1.close();
    ArchSalida2.close();
    ArchSalida3.close();

    return 0;
}
