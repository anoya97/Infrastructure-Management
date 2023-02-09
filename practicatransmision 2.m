%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%


clear all;
close all;

%=================== Parametros ==================================
N=10;		 % Periodo de simbolo
L=10;		 % Numero de bits a transmitir
tipopulso=4; %1: pulso rectangular



%=================== Generacion del pulso =========================

n=0:N-1;
pulso=zeros(1,N); %Así ya reservamos memoria para el pulso

if tipopulso == 1  %pulso rectangular
  pulso(:) = 1; %Los dos puntos es para coger todos los elementos
elseif tipopulso == 2 %escrina un elseif por cda tipo
    pulso(1:N/2) = 1;
elseif tipopulso == 3
    pulso(1:N/2) = 1;
    pulso(N/2:end) = -1;
elseif tipopulso == 4
    pulso = linspace(0,1,N);
end;


%=================== Calculo de la energia del pulso =============
%Escriba el codigo para calcular la energia

Ep = sum(pulso.^2);

%Ep = pulso * pulso.';
disp(Ep);

%=================== Generacion de la senal (modulacion) =========

bits=rand(1,L) < 0.5; %genera 0 y 1 a partir de un vector de numeros
                      %aleatorios con distribucion uniforme

%Escriba un bucle que asocie un pulso con amplitud positiva a 0 y
%un pulso con amplitud negativa a 1

s_mod = [];
for k = 1:L
    Ak = 1 - 2*bits(k);
    s_mod = [s_mod, pulso*Ak];
end

%=================== Representacion grafica ===================
figure(1)
plot(n,pulso);
title('Pulso transmitido: p(n)');
grid;

figure(2)
%Escriba el codigo para representar la senal

plot(s_mod, 'LineWidth', 2);
title('Señal transmitida: s(n)');
grid;
