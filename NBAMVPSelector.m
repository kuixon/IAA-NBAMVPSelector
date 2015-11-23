%INICIO - POSIBLES EJEMPLOS
%seleccionarMVP('Rajon Rondo', 15, 4, 8, 29, 7);%sinOpcionesMVP
%seleccionarMVP('Paul George', 6, 7, 3, 45, 2);%sinOpcionesMVP
%seleccionarMVP('Ricky Rubio', 12, 4, 9, 45, 10);%sinOpcionesMVP
%seleccionarMVP('Paul Pierce', 17, 10, 10, 48, 5);%sinOpcionesMVP
%seleccionarMVP('Damian Lillard', 22, 1, 11, 50, 6);%sinOpcionesMVP
%seleccionarMVP('Blake Griffin', 25, 12, 2, 50, 5);%sinOpcionesMVP
%seleccionarMVP('Rusell Westbrook', 34, 10, 12, 30, 4);%sinOpcionesMVP
%seleccionarMVP('Kobe Bryant', 24, 9, 8, 50, 5);%conOpcionesMVP
%seleccionarMVP('Carmelo Anthony', 25, 8, 2, 38, 2);%dudoso
%seleccionarMVP('Stephen Curry', 28, 1, 2, 39, 1);%pocasOpcionesMVP
%seleccionarMVP('James Harden', 28, 7, 6, 39, 2);%conOpcionesMVP
%seleccionarMVP('Kevin Durant', 30, 7, 2, 49, 1);%conOpcionesMVP
%seleccionarMVP('Lebron James', 27, 8, 7, 55, 1);%favoritoMVP
%FIN - POSIBLES EJEMPLOS

%INICIO - INTERFAZ GRÁFICA
function varargout = SelectorCandidatosMVPdeLaNBA(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectorCandidatosMVPdeLaNBA_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectorCandidatosMVPdeLaNBA_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function SelectorCandidatosMVPdeLaNBA_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);

function varargout = SelectorCandidatosMVPdeLaNBA_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function puntos_Callback(hObject, eventdata, handles)
puntos = str2double(get(hObject, 'String'));
if isnan(puntos)
    set(hObject, 'String', 0);
    errordlg('Tiene que ser un número','Error');
end

handles.metricdata.puntos = puntos;
guidata(hObject,handles)


function puntos_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rebotes_Callback(hObject, eventdata, handles)
rebotes = str2double(get(hObject, 'String'));
if isnan(rebotes)
    set(hObject, 'String', 0);
    errordlg('Tiene que ser un número','Error');
end

handles.metricdata.rebotes = rebotes;
guidata(hObject,handles)

function rebotes_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function asistencias_Callback(hObject, eventdata, handles)
asistencias = str2double(get(hObject, 'String'));
if isnan(asistencias)
    set(hObject, 'String', 0);
    errordlg('Tiene que ser un número','Error');
end

handles.metricdata.asistencias = asistencias;
guidata(hObject,handles)

function asistencias_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function porcentaje_Callback(hObject, eventdata, handles)
porcentaje = str2double(get(hObject, 'String'));
if isnan(porcentaje)
    set(hObject, 'String', 0);
    errordlg('Tiene que ser un número','Error');
end

handles.metricdata.porcentaje = porcentaje;
guidata(hObject,handles)

function porcentaje_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clasificacion_Callback(hObject, eventdata, handles)
clasificacion = str2double(get(hObject, 'String'));
if isnan(clasificacion)
    set(hObject, 'String', 0);
    errordlg('Tiene que ser un número','Error');
end

handles.metricdata.clasificacion = clasificacion;
guidata(hObject,handles)


function clasificacion_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nombre_Callback(hObject, eventdata, handles)
nombre = get(hObject, 'String');
if isempty(nombre)
    set(hObject, 'String', 'Nombre del jugador...');
    errordlg('El nombre debe contener al menos un caracter','Error');
end

handles.metricdata.nombre = nombre;
guidata(hObject,handles)


function nombre_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function calcular_Callback(hObject, eventdata, handles) 
puntos = str2double(get(handles.puntos, 'String'));
rebotes = str2double(get(handles.rebotes, 'String'));
asistencias = str2double(get(handles.asistencias, 'String'));
porcentaje = str2double(get(handles.porcentaje, 'String'));
clasificacion = str2double(get(handles.clasificacion, 'String'));
resultado = seleccionarMVP(puntos, rebotes, asistencias, porcentaje, clasificacion);
set(handles.probabilidad, 'String', resultado);

%Contenido para añadir a la lista
contenidoLista = get(handles.nombre, 'String');
contLista = strcat(contenidoLista, '-',num2str(resultado),'%');

% Obtiene todos el contenido de la lista 
lista = get(handles.listaJugadores, 'String'); 
if ischar(lista); lista = cellstr(lista); end

% Agrega el nuevo Item en la lista 
lista = [lista; contLista]; 

% Muestra el nuevo Item en la lista 
set(handles.listaJugadores, 'String', lista);


function reset_Callback(hObject, eventdata, handles)
initialize_gui(gcbf, handles, true);


function initialize_gui(fig_handle, handles, isreset)
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.nombre = 'Nombre del jugador...';
handles.metricdata.puntos = 0;
handles.metricdata.rebotes  = 0;
handles.metricdata.asistencias  = 0;
handles.metricdata.porcentaje  = 0;
handles.metricdata.clasificacion  = 0;

set(handles.nombre, 'String', handles.metricdata.nombre);
set(handles.puntos, 'String', handles.metricdata.puntos);
set(handles.rebotes,  'String', handles.metricdata.rebotes);
set(handles.asistencias,  'String', handles.metricdata.asistencias);
set(handles.porcentaje,  'String', handles.metricdata.porcentaje);
set(handles.clasificacion,  'String', handles.metricdata.clasificacion);
set(handles.probabilidad, 'String', 0);

guidata(handles.figure1, handles);

function listaJugadores_Callback(hObject, eventdata, handles)


function listaJugadores_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%FIN - INTERFAZ GRÁFICA


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

function resultado = Y(x,y)
resultado = min(x,y);

function resultado = O(x,y)
resultado = max(x,y);

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
%FIN - APARTADO LÓGICA DIFUSA