function NBA_MVP_Selector
clc
warning off

minResMVP = 55;
jug_ent = dlmread('jugadoresEntrenamiento.txt',' ',1,0);
val_jug_can = dlmread('jugadoresCandidatosValores.txt',',',1,0);
%nombres_jugadores_candidatos = textread('jugadoresCandidatosNombres.txt','%s','\n','');
index = 0;
for i = 1 : size(val_jug_can,1)
    if seleccionarMVP(val_jug_can(i,1),val_jug_can(i,2),val_jug_can(i,3),val_jug_can(i,4),val_jug_can(i,5)) > minResMVP
        index = index + 1;
    end
end

favoritos_mvp = zeros(index,5);
index = 1;
for i = 1 : size(val_jug_can,1)
    if seleccionarMVP(val_jug_can(i,1),val_jug_can(i,2),val_jug_can(i,3),val_jug_can(i,4),val_jug_can(i,5)) > minResMVP
        favoritos_mvp(index,:) = val_jug_can(i,:);
        index = index + 1;
    end
end
%Jugadores obtenidos despues de la preselección con lógica difusa.
favoritos_mvp



%INICIO - APARTADO LÓGICA DIFUSA
function resultado = seleccionarMVP(puntos,rebotes,asistencias,tiroDeCampo,posicionEquipo)
%Definición de la Base de Datos
anotadorMalo = [0 0 8 11];
anotadorRegular = [8 11 18 20];
anotadorBueno = [18 20 60 60];

reboteadorMalo = [0 0 4 6];
reboteadorRegular = [4 6 8 9];
reboteadorBueno = [8 9 25 25];

asistenteMalo = [0 0 3 5];
asistenteRegular = [3 5 7 8];
asistenteBueno = [7 8 25 25];

tiroDeCampoMalo = [0 0 30 35];
tiroDeCampoRegular = [30 35 40 45];
tiroDeCampoBueno = [40 45 50 60];
tiroDeCampoMuyBueno = [50 60 100 100];

posicionEquipoBuena = [0 0 3 4];
posicionEquipoRegular = [3 4 8 9];
posicionEquipoMala = [8 9 15 15];

favoritoMVP = 100;
conOpcionesDeMVP = 75;
dudosoMVP = 50;
pocasOpcionesMVP = 25;
sinOpcionesMVP = 0;

%Fuzzificación
mu_anotadorMalo = Mu(puntos,anotadorMalo);
mu_anotadorRegular = Mu(puntos,anotadorRegular);
mu_anotadorBueno = Mu(puntos,anotadorBueno);

mu_reboteadorMalo = Mu(rebotes,reboteadorMalo);
mu_reboteadorRegular = Mu(rebotes,reboteadorRegular);
mu_reboteadorBueno = Mu(rebotes,reboteadorBueno);

mu_asistenteMalo = Mu(asistencias, asistenteMalo);
mu_asistenteRegular = Mu(asistencias, asistenteRegular);
mu_asistenteBueno = Mu(asistencias, asistenteBueno);

mu_tiroDeCampoMalo = Mu(tiroDeCampo, tiroDeCampoMalo);
mu_tiroDeCampoRegular = Mu(tiroDeCampo, tiroDeCampoRegular);
mu_tiroDeCampoBueno = Mu(tiroDeCampo, tiroDeCampoBueno);
mu_tiroDeCampoMuyBueno = Mu(tiroDeCampo, tiroDeCampoMuyBueno);

mu_posicionEquipoMala = Mu(posicionEquipo, posicionEquipoMala);
mu_posicionEquipoRegular = Mu(posicionEquipo, posicionEquipoRegular);
mu_posicionEquipoBuena = Mu(posicionEquipo, posicionEquipoBuena);

%Base de Reglas
basereglas = [%Si tiene un mal porcentaje en tiros de campo no tiene opciones.
              mu_tiroDeCampoMalo                                       sinOpcionesMVP
              %Si es un anotador malo o regular no tiene opciones de MVP.
              O(mu_anotadorMalo,mu_anotadorRegular)                    sinOpcionesMVP
              %Si su posición de equipo ha sido mala no tiene
              %opciones.
              mu_posicionEquipoMala                                    sinOpcionesMVP
              %Si la posición del equipo es regular y es una anotador malo
              %o regular no tiene opciones de ser MVP.
              Y(mu_posicionEquipoRegular,O(mu_anotadorMalo,mu_anotadorRegular)) sinOpcionesMVP
              %Si la posición del equipo es regular y el jugador es buen anotador, pero, tiene un
              %porcentaje de tiros de campo malo o regular; o es un
              %reboteador o asistente malo o regular no tiene opciones de
              %ser MVP.
              Y(Y(mu_posicionEquipoRegular, mu_anotadorBueno),O(O(mu_tiroDeCampoMalo,mu_tiroDeCampoRegular),O(O(mu_reboteadorMalo,mu_reboteadorRegular),O(mu_asistenteMalo,mu_asistenteRegular)))) sinOpcionesMVP
              %Si su posición de equipo es regular, pero es buen anotador y
              %además tiene un porcentaje de tiros de campo alto o muy alto
              %y es buen reboteador y buen asistente; tiene opciones pero
              %no es favorito (es muy importante la posición del equipo).
              Y(Y(mu_posicionEquipoRegular,mu_anotadorBueno),Y(O(mu_tiroDeCampoBueno,mu_tiroDeCampoMuyBueno),Y(mu_reboteadorBueno,mu_asistenteBueno)))    conOpcionesDeMVP
              %Si la posición de su equipo es buena y es buen anotador,
              %pero, su porcentaje en tiros de campo es regular va a ser
              %dudoso (en principio).
              Y(Y(mu_posicionEquipoBuena,mu_anotadorBueno),mu_tiroDeCampoRegular)   dudosoMVP
              %Si la posición de su equipo es buena y es buen anotador,
              %pero, su porcentaje de tiros de campo es regular y; además,
              %es mal reboteador y asistente tiene pocas opciones de ser
              %MVP.
              Y(Y(mu_posicionEquipoBuena,mu_anotadorBueno),Y(mu_tiroDeCampoRegular,Y(mu_reboteadorMalo, mu_asistenteMalo))) pocasOpcionesMVP
              %Si la posición de su equipo es buena y es buen anotador,
              %pero, su porcentaje de tiros de campo es regular y; además,
              %es un reboteador y asistente regular o bueno tiene opciones
              %de ser MVP.
              Y(Y(mu_posicionEquipoBuena,mu_anotadorBueno),Y(mu_tiroDeCampoRegular,Y(O(mu_reboteadorRegular,mu_reboteadorBueno), O(mu_asistenteRegular,mu_asistenteBueno))))    conOpcionesDeMVP
              %Si la posición de su equipo es buena, es buen anotador y
              %tiene un porcetaje de tiros de campo bueno o muy bueno,
              %pero, es un reboteador o asistente malo tiene opciones de
              %ser MVP.
              Y(Y(Y(mu_posicionEquipoBuena,mu_anotadorBueno),O(mu_tiroDeCampoBueno,mu_tiroDeCampoMuyBueno)),O(mu_reboteadorMalo,mu_asistenteMalo))    conOpcionesDeMVP
              %Si la posición de su equipo es buena, es buen anotador,
              %tiene un porcetaje de tiros de campo bueno o muy bueno y,
              %además es un asistente y reboteador regular o bueno es
              %favorito.
              Y(Y(mu_posicionEquipoBuena,mu_anotadorBueno),Y(O(mu_tiroDeCampoBueno,mu_tiroDeCampoMuyBueno),Y(O(mu_reboteadorRegular,mu_reboteadorBueno),O(mu_asistenteRegular,mu_asistenteBueno))))    favoritoMVP];
          
%Defuzzificación
antecedentes = basereglas(:,1);
consecuentes = basereglas(:,2);

resultado = sum(antecedentes.*consecuentes)/sum(antecedentes);
end

function resultado = Y(x,y)
resultado = min(x,y);
end

function resultado = O(x,y)
resultado = max(x,y);
end

function resultado = Mu(x,conjunto)
    a = conjunto(1);
    b = conjunto(2);
    c = conjunto(3);
    d = conjunto(4);

    if  (x<a)
        resultado = 0;
    elseif (x<b)
        resultado = (x-a)/(b-a);
    elseif (x<c)
        resultado = 1;
    elseif (x<d)
        resultado = (d-x)/(d-c);
    else
        resultado = 0;
    end
end
%FIN - APARTADO LÓGICA DIFUSA

end

