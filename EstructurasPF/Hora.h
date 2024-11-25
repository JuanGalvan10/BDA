#ifndef HORA_H
#define HORA_H

#include <iostream>
using namespace std;
#include <string>

class Hora
{
public:
    Hora();
    Hora(int h, int m);
    Hora(const string &tiempo); // Constructor que recibe un string

    void setHora(int h) { hh = h; }; // regresa horas enteras
    void setMin(int m) { mm = m; };  // que regresa minutos enteros
    int getHora() { return hh; };
    int getMin() { return mm; };
    int aMin(Hora hora);
    Hora aHora(int min);
    friend istream &operator>>(istream &is, Hora &dato);
    friend ostream &operator<<(ostream &os, Hora dato);
    bool operator<=(Hora h);
    bool operator>=(Hora h);
    bool operator==(Hora h);
    Hora operator+(int min) const;

private:
    int hh, mm;
};

Hora ::Hora()
{
    hh = 0;
    mm = 0;
}

Hora::Hora(int h, int m)
{
    hh = h;
    mm = m;
}

int Hora::aMin(Hora hora){
    return hora.hh * 60 + hora.mm;
}

Hora Hora::aHora(int min)
{
    Hora horaFinal;
    if (min < 0)
    {
        min = (24 * 60 + min) % (24 * 60);
    }
    horaFinal.hh = (min / 60) % 24; 
    horaFinal.mm = min % 60;
    return horaFinal;
}

Hora::Hora(const string &tiempo)
{
    string npos;
    size_t separador = tiempo.find(':'); // Buscar el separador ":"
    if (separador != string::npos)
    {
        hh = stoi(tiempo.substr(0, separador));  // Extraer las horas
        mm = stoi(tiempo.substr(separador + 1)); // Extraer los minutos
    }
    else
    {
        hh = 0;
        mm = 0;
        cerr << "Formato inválido: " << tiempo << endl;
    }
}

istream &operator>>(istream &is, Hora &dato)
{
    is >> dato.hh;
    is >> dato.mm;
    return is;
}

ostream &operator<<(ostream &os, Hora dato)
{
    if (dato.hh < 10)
    {
        os << "0" << dato.hh << ":";
    }
    else
        (os << dato.hh << ":");

    if (dato.mm < 10)
    {
        os << "0" << dato.mm;
    }
    else
        (os << dato.mm);
    return os;
}

bool Hora::operator==(Hora h)
{
    if (hh == h.hh && mm == h.mm)
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool Hora::operator<=(Hora h)
{
    int misMin = hh * 60 + mm;
    int minP = h.hh * 60 + h.mm;
    if (misMin <= minP)
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool Hora::operator>=(Hora h)
{
    int misMin = hh * 60 + mm;
    int minP = h.hh * 60 + h.mm;
    if (misMin >= minP)
    {
        return true;
    }
    else
    {
        return false;
    }
}

#endif