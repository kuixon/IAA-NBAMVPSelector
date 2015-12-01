function NBA_MVP_Selector
clc
%warning off

minResMVP = 55;
jug_ent = dlmread('jugadoresEntrenamiento.txt',' ',1,0);
val_jug_can = dlmread('jugadoresCandidatosValores.txt',',',1,0);
%nombres_jugadores_candidatos = textread('jugadoresCandidatosNombres.txt','%s','\n','');
index = 0;
for i = 1 : size(val_jug_can,1)
    if seleccionarFavoritosMVP(val_jug_can(i,1),val_jug_can(i,2),val_jug_can(i,3),val_jug_can(i,4),val_jug_can(i,5)) > minResMVP
        index = index + 1;
    end
end

favoritos_mvp = zeros(index,5);
index = 1;
for i = 1 : size(val_jug_can,1)
    if seleccionarFavoritosMVP(val_jug_can(i,1),val_jug_can(i,2),val_jug_can(i,3),val_jug_can(i,4),val_jug_can(i,5)) > minResMVP
        favoritos_mvp(index,:) = val_jug_can(i,:);
        index = index + 1;
    end
end
%Jugadores obtenidos despues de la preselección con lógica difusa.
favoritos_mvp

minPuntos = min(jug_ent(:,1));
maxPuntos = max(jug_ent(:,1));
fprintf('\nPuntos: Maximo: %d - Minimo: %d', maxPuntos, minPuntos);

minRebotes = min(jug_ent(:,2));
maxRebotes = max(jug_ent(:,2));
fprintf('\nRebotes: Maximo: %d - Minimo: %d', maxRebotes, minRebotes);

minAsistencias = min(jug_ent(:,3));
maxAsistencias = max(jug_ent(:,3));
fprintf('\nAsistencias: Maximo: %d - Minimo: %d', maxAsistencias, minAsistencias);

minTC = min(jug_ent(:,4));
maxTC = max(jug_ent(:,4));
fprintf('\nTC: Maximo: %d - Minimo: %d', maxTC, minTC);

fprintf('\nPosicion Equipo: Maximo: %d - Minimo: %d', 15, 1);

end

%INICIO - APARTADO LÓGICA DIFUSA
function resultado = seleccionarFavoritosMVP(puntos,rebotes,asistencias,tiroDeCampo,posicionEquipo)
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

% INICIO - APARTADO RAZONAMIENTO PROBABILÍSTICO
function resultado2 = seleccionarMVP(datos_test, datos_entrenamiento)
for dato = 1 : size(datos_test,1)
    % Obtenemos el dato de una fila
    dato_prueba = datos_test(dato,:);
    % Se muestra el numero de fila
    fprintf('\nDato de Prueba %d: ',dato);
    % Se muestran todas las columnas de la fila
    for j=1:size(datos_test,2)
        fprintf('%d ',dato_prueba(j))
    end
    fprintf('\n')
    % Se obtienen las estimaciones posibles sin repetir de la ultima
    % columna
    Estimaciones = unique(datos_entrenamiento(:,end))';
    % Se crea una matriz de probabilidades de una unica fila y dos columnas
    % (estimaciones)
    Probabilidades = ones(1,numel(Estimaciones));
    
    % Se recorren los tipos de estimaciones
    % En la primera vuelta obtiene todos los datos con estimacion 0
    % En la segunda vuelta obtiene todos los datos con estimacion 1
    for est = 1:numel(Estimaciones)
        tabla = datos_entrenamiento(datos_entrenamiento(:,end)==Estimaciones(est),:);
        %% Calcular Probabilidades(est) <-------****
        %  Probabilidades(est) = P(ultimacolumna=Estimaciones(est))
        Probabilidades(est) = (size(tabla,1) + 1/2) / (size(datos_entrenamiento,1) + 1);
        
        % Se crea un vector para almacenar los resultados para cada una de
        % las columnas
        numProbabilities = zeros(1, size(datos_entrenamiento, 2) - 1);
        
        % Se recorren cada una de las columnas
        for i = 1: size(datos_entrenamiento, 2) - 1
            vector = [];
            if i == 1
                vector = GROUP_AGES;
            elseif i == 2
                vector = GROUP_YEARS;
            elseif i == 3
                vector = GROUP_POSITIVES;
            end
            
            % Se obtiene el grupo al que pertenece el valor de la columna
            group = [];
            for x = 1: size(vector, 2)
                if size(vector(vector(:,x) == dato_prueba(i),:)) > 0
                    group = vector(vector(:,x) == dato_prueba(i),:);
                    break
                end
            end
            
            % Se comprueba el numero de filas que pertenecen al grupo del
            % dato de prueba
            numFilasCumplen = 0;
            for x = 1 : size(vector, 2)
                numFilasCumplen = numFilasCumplen + size(tabla(tabla(:,i) == group(x),:),1);
            end
            
            % Calculamos la probabilidad
            numProbabilities(i) = ((numFilasCumplen + (1 / size(vector, 1))) / (size(tabla, 1) + 1));             
        end
        
        % Se suman las probabilidades de cada una de las columnas
        for i = 1: size(datos_entrenamiento, 2) - 1
            Probabilidades(est) = Probabilidades(est) * numProbabilities(i);
        end
                
    end
    
    for est = 1:numel(Estimaciones)
        fprintf('\tEstimación de %d: ',Estimaciones(est))
        fprintf('%.8f\t%.2f\n',Probabilidades(est),Probabilidades(est)/sum(Probabilidades));
        if Probabilidades(est)==max(Probabilidades)
            estimacion_ganadora = Estimaciones(est);
        end
    end
    fprintf('\t\tEstimación Obtenida/Esperada: %d %d\n',estimacion_ganadora,dato_prueba(end))
    if estimacion_ganadora == dato_prueba(end)
        aciertos = aciertos+1;
    end  
end
end
% FIN - APARTADO RAZONAMIENTO PROBABILÍSTICO

