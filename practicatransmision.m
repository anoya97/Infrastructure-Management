%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%


clear all;
close all;

%=================== Parametros ==================================
N=10;		 % Periodo de simbolo
L=10;		 % Numero de bits a transmitir
tipopulso=4; %1: pulso rectangular 
EbNo=10 ; % EbNo en dB

W=pi/8; % Ancho de banda del canal
        

%=================== Generacion del pulso =========================

n=0:N-1;
%pulso=zeros(1,N); %Así ya reservamos memoria para el pulso
%pulso(1:N/2)=ones;
%pulso(N/2+1:N)=zeros;
pulso=n/(N-1);

if tipopulso == 1  %pulso rectangular
  pulso(:) = 1; %Los dos puntos es para coger todos los elementos 
elseif tipopulso == 2 %escrina un elseif por cda tipo
    pulso(1:N/2) = 1;
elseif tipopulso == 3
    pulso(1:N/2) = 1;
    pulso(N/2:end) = -1;
elseif tipopulso == 4   
    pulso = linspace(0,1,N);
end

%--------------- Generación del canal ---------------------
NL2=fix(N*L/2);
n2=-NL2:NL2-1;
h=sin(W*n2)./(pi*n2); pos=find(n2==0);
h(pos)=W/pi;
if (pi/N)>W
    h=h*pi/W/N;
end
%=================== Calculo de la energia del pulso =============
%Escriba el codigo para calcular la energia

Ep = sum(pulso.^2);

Eb=Ep;

%Ep = pulso * pulso.';
disp(Ep);

%=================== Generacion de la senal (modulacion) =========
%Cambio a unidades naturales y calculo de No
EbNo=10^(EbNo/10);
No=Eb/EbNo;
ruido=sqrt(No/2)*randn(1,N*L); %generación del ruido


bits=rand(1,L) < 0.5; %genera 0 y 1 a partir de un vector de numeros 
                      %aleatorios con distribucion uniforme

%Escriba un bucle que asocie un pulso con amplitud positiva a 0 y 
%un pulso con amplitud negativa a 1

s_mod = [];
for k = 1:L
    Ak = 1 - 2*bits(k);
    s_mod = [s_mod, pulso*Ak];
end

%s_rec=s_mod+ruido;
s_rec=conv(s_mod,h);
s_rec=s_rec(NL2+1:length(s_rec)-NL2+1);
ruido=sqrt(No/2)*rand(1,N*L);
s_rec=s_rec+ruido;



%=================== Representacion grafica ===================
figure(1)
plot(n,pulso);
title('Pulso transmitido: p(n)');
grid;
 
figure(2)
%Escriba el codigo para representar la senal 

plot(s_mod, 'LineWidth', 2);
title('Señal transmitida: s(n)');
hold on
plot(s_rec, 'LineWidth', 2);
hold off
grid;

diagramaojo(s_rec, N, L);
%--------- calcular y representar la transformada de Fouirer ---------

[H,Wrad]=dtft(h,(2*L*N)+50);
[P,Wrad]=dtft(pulso,(2*L*N)+50);
figure; plot(Wrad,abs(P)/max(abs(P)));
grid;
hold on;
plot(Wrad,abs(H)/max(abs(H)),'r');
title('Respuesta en frecuencia del canal H(W) y T.F. del pulso P(W)');


figure;
plot(0:N*L-1,s_mod);
hold on;
plot(0:N*L-1,s_rec,'r');
axis([0 N*L-1-2 2]);
title('Senal modulada y recibida');

