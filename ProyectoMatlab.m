% Proyecto Final - Procesamiento Digital De Señales.
% Tema - Transformada De Fourier.
% Aplicación: Filtro de Ruido, Filtro Pasa Alta y Pasa Baja.

clear all, close all, clc, clf

% -------------------------------------------------------------------------
% Se empieza leyendo todas las señales a usar.
% -------------------------------------------------------------------------

[FiltroPasaAltaPrueba,FS1] = audioread('D:\ProyectoProcesamiento\Fur Elise\Final Files\FiltroPasaAlta - Prueba.mp3');
[FiltroPasaBajaPrueba,FS2] = audioread('D:\ProyectoProcesamiento\Fur Elise\Final Files\FiltroPasaBaja - Prueba.mp3');
[FiltroRuidoPrueba,FS3] = audioread('D:\ProyectoProcesamiento\Fur Elise\Final Files\FiltroRuido - Prueba.mp3');
[PrincipalManoDerecha,FS4] = audioread('D:\ProyectoProcesamiento\Fur Elise\Final Files\Principal - Mano Derecha.mp3');
[PrincipalManoIzquierda,FS5] = audioread('D:\ProyectoProcesamiento\Fur Elise\Final Files\Principal - Mano Izquierda.mp3');
[PiezaCompleta,FS6] = audioread('D:\ProyectoProcesamiento\Fur Elise\Final Files\Main.mp3');
[ComposicionCompleta,FS7] = audioread('D:\ProyectoProcesamiento\Fur Elise\Final Files\MonoMainCombination.mp3');

% -------------------------------------------------------------------------
% Filtro Pasa Baja y Pasa Alta.
% -------------------------------------------------------------------------

length(FiltroPasaBajaPrueba);    % Se lee la longitud del vector de señal.
N = 20;                         % Se asigna un valor para N.
FiltroPasaBajaPrueba = FiltroPasaBajaPrueba(1:2^N);     % Se corta el vector.
FiltroPasaAltaPrueba = FiltroPasaAltaPrueba(1:2^N);     % Se corta el vector.

% Se ve la señal original antes de aplicar el filtro pasa bajas.
figure(1)
plot(FiltroPasaBajaPrueba)
title('Señal De Audio Original - Filtro Pasa Bajas') 
xlabel('Número de Muestras') 
ylabel('Amplitud') 
grid

% Se observa la señal original antes de aplicar el filtro pasa altas.
figure(2)
plot(FiltroPasaAltaPrueba)
title('Señal De Audio Original - Filtro Pasa Altas') 
xlabel('Número de Muestras') 
ylabel('Amplitud') 
grid

% Se obtiene el valor absoluto de la FFT original.
FFT_original_abs1 = abs(fftshift(fft(FiltroPasaBajaPrueba)));
FFT_original_abs2 = abs(fftshift(fft(FiltroPasaAltaPrueba)));

% Se aplica el filtro primero creando un vector de frecuencias para el eje x de la FFT.
VectorFrecuencia = (-2^(N-1):(2^(N-1)-1));
FFT_filtrada1 = fftshift(fft(FiltroPasaBajaPrueba));
FFT_filtrada2 = fftshift(fft(FiltroPasaAltaPrueba));

% Filtro Pasa Bajas
FFT_filtrada1(abs(VectorFrecuencia)>30000) = 0;

% Filtro Pasa Altas
FFT_filtrada2(abs(VectorFrecuencia)<15000) = 0;

% Filtro Pasa Banda
% FFT_filtrada3((abs(VectorFrecuencia)>100)&(abs(VectorFrecuencia)<1000)) = 0;

% Se obtiene valores absolutos de la señal filtrada para verla en una gráfica.
FFT_filtrada_abs1 = abs((FFT_filtrada1));
FFT_filtrada_abs2 = abs((FFT_filtrada2));

% Se grafica las señales 1 obtenidas por la FFT y la señal despues de pasar por el filtro.
figure(3)
subplot(2,1,1)
plot(FFT_original_abs1,'b');
title('FFT Obtenida De La Señal 1 Original') 
ylim([0 max(FFT_original_abs1)])
subplot(2,1,2)
plot(FFT_filtrada_abs1,'r');
title('FFT De La Señal 1 Despues De Pasar Por El Filtro') 
ylim([0 max(FFT_original_abs1)])

% Se grafica las señales 2 obtenidas por la FFT y la señal despues de pasar por el filtro.
figure(4)
subplot(2,1,1)
plot(FFT_original_abs2,'b');
title('FFT Obtenida De La Señal 2 Original') 
ylim([0 max(FFT_original_abs2)])
subplot(2,1,2)
plot(FFT_filtrada_abs2,'r');
title('FFT De La Señal 2 Despues De Pasar Por El Filtro') 
ylim([0 max(FFT_original_abs2)])

% Se obtienen las señales filtradas.
f_nofiltrada1 = ifft(fft(FiltroPasaBajaPrueba));
f_nofiltrada2 = ifft(fft(FiltroPasaAltaPrueba));
f_filtrada1 = real(ifft(fftshift(FFT_filtrada1)));
f_filtrada2 = real(ifft(fftshift(FFT_filtrada2)));
% sound(f_nofiltrada1,FS1)
% sound(f_nofiltrada2,FS1)
% sound(f_filtrada1,FS1)
% sound(f_filtrada2,FS1)

% -------------------------------------------------------------------------
% Filtro De Ruido.
% -------------------------------------------------------------------------

% Se recorta la señal introducida.
dt = 1/44100;
t = 0:dt:23.77723356;

PrincipalManoIzquierda = PrincipalManoIzquierda(1:1048576);
PrincipalManoIzquierda = transpose(PrincipalManoIzquierda);
PrincipalManoIzquierdaLimpia = PrincipalManoIzquierda;

% Se agrega ruido sintético para cuestiones de prueba.
random = transpose(0.01*randn(size(t)));
PrincipalManoIzquierda = PrincipalManoIzquierda + random; 

% Se calcula la FFT.
n = length(t);
FFT_Senal_Ruido = fft(PrincipalManoIzquierda,n);       
EspectroPotencia = FFT_Senal_Ruido.*conj(FFT_Senal_Ruido)/n;     % Se visualiza un espectro de potencia.
Frecuencia = 1/(dt*n)*(0:n);                        % Se crea un vector de frecuencias en x para la gráfica.
L = 1:floor(n/2);                                   % Se gráfica solo una parte de las frecuencias calculadas.

% Se usa el espectro en potencia para filtrar el ruido de la señal.
Indices = EspectroPotencia>0.001;                            % Se encuentran las frecuencias que tengan potencia mayor a 0.001
EspectroPotencia_limpio = EspectroPotencia.*Indices;                      % Se le asigna amplitud de cero a todas las demás frecuencias.
FFT_Senal_Ruido = Indices.*FFT_Senal_Ruido;     % Se le asigna cero a los coeficientes de Fourier pequeños.
FFT_filtrada_ruido = ifft(FFT_Senal_Ruido);     % Aplicamos IFFT a la señal filtrada.

% Gráficas de los cálculos obtenidos.
figure(5)
subplot(3,1,1)
plot(t,PrincipalManoIzquierda,'r','LineWidth',1.2), hold on
plot(t,PrincipalManoIzquierdaLimpia,'k','LineWidth',1.5)
title('Comparación entre la señal original limpia y la señal ruidosa') 
legend('Señal original ruidosa','Señal original limpia')

subplot(3,1,2)
plot(t,PrincipalManoIzquierdaLimpia,'r','LineWidth',1.5), hold on
plot(t,FFT_filtrada_ruido,'k','LineWidth',1.2)
title('Comparación entre la señal original limpia y la señal filtrada') 
legend('Señal original limpia','Señal limpiada por filtro')

subplot(3,1,3)
plot(Frecuencia(L),EspectroPotencia(L),'r','LineWidth',1.5)
title('Transformada de Fourier Realizada') 
legend('FFT')

% Se obtienen las señales filtradas.
% sound(PrincipalManoIzquierda,44000)
% sound(FFT_filtrada_ruido,44000)

% -------------------------------------------------------------------------
% Edición de las señales finales.
% -------------------------------------------------------------------------

% Se cortan algunas de nuestras señales.
PrincipalManoDerecha = PrincipalManoDerecha(1:1048576);
PrincipalManoIzquierda = PrincipalManoIzquierda(1:1048576);
PrincipalManoDerecha = transpose(PrincipalManoDerecha);

PiezaCompleta = PiezaCompleta(1:1048576);
ComposicionCompleta = ComposicionCompleta(1:1048576);
PiezaCompleta = transpose(PiezaCompleta);
ComposicionCompleta = transpose(ComposicionCompleta);

% Reproducción de todas las señales.
% sound(f_nofiltrada1,FS1)                %Filtro Pasa Baja
% sound(f_filtrada1,FS1)                %Filtro Pasa Baja
% sound(f_nofiltrada2,FS1)            %Filtro Pasa Alta
% sound(f_filtrada2,FS1)                %Filtro Pasa Alta
% sound(PrincipalManoIzquierdaLimpia,FS5)       %Filtro Ruido
% sound(PrincipalManoIzquierda,FS5)                 %Filtro Ruido
% sound(FFT_filtrada_ruido,FS5)                         %Filtro Ruido
% sound(PrincipalManoDerecha,FS5)           %Señal Original
% sound(PiezaCompleta,FS5) 
% sound(ComposicionCompleta,FS5)

% Se observan los resultados obtenidos.
figure(6)
subplot(3,1,1)
plot(t,f_nofiltrada1,'r','LineWidth',1.2), hold on
plot(t,f_filtrada1,'k','LineWidth',1.5)
title('Resultados de filtro pasa bajas') 
legend('Señal original','Señal filtrada')

subplot(3,1,2)
plot(t,f_nofiltrada2,'r','LineWidth',1.2), hold on
plot(t,f_filtrada2,'k','LineWidth',1.5)
title('Resultados de filtro pasa altas') 
legend('Señal original','Señal filtrada')

subplot(3,1,3)
plot(t,PrincipalManoIzquierda,'r','LineWidth',1.2), hold on
plot(t,FFT_filtrada_ruido,'k','LineWidth',1.5)
title('Resultados de filtro de ruido') 
legend('Señal original','Señal filtrada')

% Se observan los resultados obtenidos.
figure(7)
subplot(3,1,1)
plot(t,abs(fftshift(fft(f_nofiltrada1))),'r','LineWidth',1.2), hold on
plot(t,abs(fftshift(fft(f_filtrada1))),'k','LineWidth',1.5)
title('Resultados de filtro pasa bajas') 
legend('Señal original','Señal filtrada')

subplot(3,1,2)
plot(t,abs(fftshift(fft(f_nofiltrada2))),'r','LineWidth',1.2), hold on
plot(t,abs(fftshift(fft(f_filtrada2))),'k','LineWidth',1.5)
title('Resultados de filtro pasa altas') 
legend('Señal original','Señal filtrada')

subplot(3,1,3)
plot(t,abs(fftshift(fft(PrincipalManoIzquierda))),'r','LineWidth',1.2), hold on
plot(t,abs(fftshift(fft(FFT_filtrada_ruido))),'k','LineWidth',1.5)
title('Resultados de filtro de ruido') 
legend('Señal original','Señal filtrada')

% Se crea una rampa para aplicarla a la señal final.
ramp1 = (1:-1/(44100*4):0);
ramp1 = transpose(ramp1);
X = ones([872175,1]);
ramp2 = [X; ramp1];

% Finalmente se agregan todas las señales en una señal final.
composicion_final = PrincipalManoDerecha + FFT_filtrada_ruido + f_filtrada1 + f_filtrada2;
composicion_final = composicion_final.*ramp2;

% -------------------------------------------------------------------------
% Composicion final.
% -------------------------------------------------------------------------

% sound(composicion_final,FS1)