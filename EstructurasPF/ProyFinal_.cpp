#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
using namespace std;
#include "LinkedListProyF.h" // Incluye una lista enlazada personalizada con métodos especializados para ciudades y recorridos.

int main()
{
    // Apertura de archivos: archivo de entrada y múltiples archivos de salida
    ifstream ArchEntrada; // Archivo para leer datos de las ciudades y recorridos.
    ArchEntrada.open("EuropeCities.csv");
    ofstream ArchSalida1("output-1.out"); // Salida para información general de las ciudades.
    ofstream ArchSalida2("output-2.out"); // Salida para recorridos BFS.
    ofstream ArchSalida3("output-3.out"); // Salida para recorridos DFS.

    // Declaración de variables para almacenar y procesar datos
    string arrdatos[250][6]; // Matriz para almacenar datos leídos del archivo (aunque no se utiliza aquí).
    string datos, linea, ciudadA, ciudadB, DxTrain_s, DxCar_s, TxTrain_s, TxCar_s; // Variables auxiliares.
    string ciudad2, ciudadi, ciudadf; // Nombres de ciudades utilizadas en los menús.
    int DxTrain, DxCar; // Distancias en tren y auto.
    int cont = 0; // Contador de líneas leídas.
    int ans = 0; // Opción seleccionada en el menú.
    bool encontrado = false; // Flag para verificar si las ciudades existen.
    LinkedListPF<string> MiCiudad; // Lista enlazada personalizada para almacenar ciudades y recorridos.

    // Verifica si el archivo de entrada pudo abrirse correctamente
    if (!ArchEntrada)
    {
        cout << "No se pudo abrir el archivo" << endl;
    }
    else
    {
        // Lectura del archivo línea por línea
        while (getline(ArchEntrada, linea))
        {
            stringstream datos(linea); // Crea un flujo de datos para procesar la línea.
            getline(datos, ciudadA, ','); // Extrae la ciudad A.
            getline(datos, ciudadB, ','); // Extrae la ciudad B.
            getline(datos, TxTrain_s, ','); // Tiempo en tren (como string).
            getline(datos, DxTrain_s, ','); // Distancia en tren (como string).
            getline(datos, TxCar_s, ','); // Tiempo en auto (como string).
            getline(datos, DxCar_s); // Distancia en auto (como string).

            // Convierte las distancias de string a entero
            DxTrain = stoi(DxTrain_s);
            DxCar = stoi(DxCar_s);

            // Convierte los tiempos de string a objetos de tipo Hora
            Hora TxTrain(TxTrain_s);
            Hora TxCar(TxCar_s);

            // Agrega las ciudades a la lista si no existen ya
            if (MiCiudad.findData(ciudadA) == -1)
            {
                MiCiudad.addCiu(ciudadA);
            }
            if (MiCiudad.findData(ciudadB) == -1)
            {
                MiCiudad.addCiu(ciudadB);
            }

            // Agrega un recorrido bidireccional entre las ciudades con ponderaciones
            MiCiudad.addRec(ciudadA, ciudadB, TxTrain, DxTrain, TxCar, DxCar);

            cont++; // Incrementa el contador de líneas procesadas.
        }
        ArchEntrada.close(); // Cierra el archivo de entrada.
    }

    // Menú principal para interactuar con el usuario
    do
    {
        cout << "       ----- MENU -----        " << endl;
        cout << "1- Desplegar Ciudad " << endl;
        cout << "2- Desplegar recorrido por medio de una ciudad " << endl;
        cout << "3- Ruta más corta" << endl;
        cout << "4- Salir" << endl;
        cin >> ans;

        switch (ans)
        {
        case 1: // Desplegar información de las ciudades en el archivo de salida 1
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

        case 2: // Generar recorridos BFS y DFS desde una ciudad especificada
            cout << "Dame una ciudad:" << endl;
            cin.ignore(); // Limpia el buffer de entrada.
            getline(cin, ciudad2); // Lee el nombre de la ciudad.

            if (MiCiudad.findData(ciudad2) >= 0) // Verifica si la ciudad existe.
            {
                if (ArchSalida2 && ArchSalida3)
                {
                    // Genera el recorrido BFS
                    ArchSalida2 << "-- BFS: Iniciando en " << ciudad2 << endl;
                    MiCiudad.BFS(ciudad2, ArchSalida2);
                    ArchSalida2 << endl;

                    // Genera el recorrido DFS
                    MiCiudad.resetProcesado(); // Reinicia estados antes de DFS.
                    ArchSalida3 << "-- DFS: Iniciando en " << ciudad2 << endl;
                    MiCiudad.DFS(ciudad2, ArchSalida3);
                    ArchSalida3 << endl;

                    // Limpia estados internos de la lista
                    MiCiudad.resetProcesado();
                    MiCiudad.clearStack();
                    MiCiudad.clearprocesados();
                      }
                else
                {
                    // Si no se pueden abrir los archivos de salida, muestra un error
                    cout << "Error al imprimir" << endl;
                }
            }
            else
            {
                // Si la ciudad no se encuentra en la lista, muestra un mensaje de error
                cout << "No se encontró esta ciudad" << endl;
            }
            break;

        case 3: // Encontrar la ruta más corta entre dos ciudades usando Dijkstra
            do
            {
                // Solicita al usuario las ciudades de inicio y fin
                cout << "Ciudad inicio: ";
                cin.ignore(); // Limpia el buffer de entrada.
                getline(cin, ciudadi); // Lee la ciudad de inicio.
                cout << "Ciudad final: ";
                getline(cin, ciudadf); // Lee la ciudad final.

                // Verifica si ambas ciudades existen en la lista
                if (MiCiudad.encontrado(ciudadi) >= 0 && MiCiudad.encontrado(ciudadf) >= 0)
                {
                    encontrado = true; // Marca como encontrado si ambas ciudades existen.
                    cout << "De " << ciudadi << " a " << ciudadf << " : " << endl;

                    // Llama al método de Dijkstra para calcular la ruta más corta
                    MiCiudad.DijkstraF(ciudadi, ciudadf);
                }
                else
                {
                    // Si alguna de las ciudades no se encuentra, muestra un mensaje de error
                    cout << "Esa ciudad no fue encontrada, intente de nuevo." << endl;
                }

            } while (!encontrado); // Repite el proceso hasta que ambas ciudades sean válidas.
            break;

        default:
            // Si el usuario selecciona una opción no válida, simplemente pasa.
            break;
        }

    } while (ans > 0 && ans < 4); // El menú se repite mientras la opción sea válida (1-3).

    // Cierre de los archivos de salida al finalizar el programa
    ArchSalida1.close();
    ArchSalida2.close();
    ArchSalida3.close();

    return 0; // Fin del programa.
}
