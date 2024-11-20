#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
using namespace std;

#include "LinkedListProyF.h"
#include "ListaAdyacencia.h"

int main()
{

    ifstream ArchEntrada;
    ArchEntrada.open("C:\\Users\\pamel\\Downloads\\UDEM\\Programacion\\Codigos\\EuropeCities.csv"); // cambia a la ruta deseada
    ofstream ArchSalida1("output-1.txt");
    ofstream ArchSalida2("output-2.txt");
    ofstream ArchSalida3("output-3.txt");

    string arrdatos[250][6];
    string datos, linea, ciudadA, ciudadB, TxTrain, DxTrain_s, TxCar, DxCar_s;
    string ciudad2;
    int DxTrain, DxCar;
    int cont = 0;
    int ans = 0;
    LinkedListPF<string> MiCiudad;

    if (!ArchEntrada)
    {
        cout << "no se pudo abrir el archivo" << endl;
    }
    else
    {
        while (getline(ArchEntrada, linea))
        {
            stringstream datos(linea);
            getline(datos, ciudadA, ',');
            getline(datos, ciudadB, ',');
            getline(datos, TxTrain, ',');
            getline(datos, DxTrain_s, ',');
            getline(datos, TxCar, ',');
            getline(datos, DxCar_s);

            DxTrain = stoi(DxTrain_s); // convertir distancia string a entero
            DxCar = stoi(DxCar_s);     // convertir distancia string a entero

            // Guarda todos las ciudades en una lista
            if (MiCiudad.findData(ciudadA) == -1)
            {
                MiCiudad.addCiu(ciudadA);
            }
            if (MiCiudad.findData(ciudadB) == -1)
            {
                MiCiudad.addCiu(ciudadB);
            }

            // guarda los arcos con su ponderacion bidireccional
            MiCiudad.addRec(ciudadA, ciudadB, DxTrain, DxCar);

            // guarda en un arreglo para dijerska idk
            arrdatos[cont][0] = ciudadA;
            arrdatos[cont][1] = ciudadB;
            arrdatos[cont][2] = TxTrain;
            arrdatos[cont][3] = DxTrain;
            arrdatos[cont][4] = TxCar;
            arrdatos[cont][5] = DxCar;
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
                cout <<  "Proceso Completado" << endl;
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
            cout << "ENTRO A 3 " << endl;
            break;
        default:
            break;
        }

    } while (ans > 0 && ans < 4);

    ArchSalida1.close();
    ArchSalida2.close();
    ArchSalida3.close();

    return 0;
}
