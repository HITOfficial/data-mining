% 1.

% Załadowanie danych z pliku CSV
data = readtable('Ukraine Explorer Inputs Prod - RefugeesSeries.csv');

load("Ukraine Explorer Inputs Prod - RefugeesSeries [matlab].mat");

% Obliczanie przyrostów bezwzględnych
delta = diff(data.NoRefugees);

% Obliczanie przyrostów względnych
delta_relative = diff(data.NoRefugees) ./ data.NoRefugees(1:end-1);

% Obliczanie przyrostów logarytmicznych
delta_log = diff(log(data.NoRefugees));

% Obliczanie średniej i odchylenia standardowego
mean_value = mean(data.NoRefugees);
std_value = std(data.NoRefugees);

% Wykresy
figure;

% Wykres przyrostu bezwzględnego
subplot(4, 3, 1);
plot(delta, 'r');
title('Przyrost bezwzględny');
xlabel('Indeks');
ylabel('Przyrost');
grid on;

% Wykres przyrostu względnego
subplot(4, 3, 2);
plot(delta_relative, 'g');
title('Przyrost względny');
xlabel('Indeks');
ylabel('Przyrost względny');
grid on;

% Wykres przyrostu logarytmicznego
subplot(4, 3, 3);
plot(delta_log, 'b');
title('Przyrost logarytmiczny');
xlabel('Indeks');
ylabel('Przyrost logarytmiczny');
grid on;

% Wykres średniej i odchylenia standardowego
subplot(4, 3, [4,5]);
plot(data.NoRefugees, 'b'); % Wykreślenie danych
hold on;
plot(mean_value * ones(size(data.NoRefugees)), 'g--'); % Wykreślenie średniej jako poziomej linii
title('Średnia i odchylenie standardowe');
xlabel('Indeks');
ylabel('Liczba uchodźców');
legend('Dane', 'Średnia');

% Obliczanie odchylenia standardowego
std_value = std(data.NoRefugees);

errorbar(1:numel(data.NoRefugees), data.NoRefugees, std_value, 'r', 'LineStyle', 'none');

legend('Dane', 'Średnia', 'Odchylenie standardowe');
grid on;


% 2.
%  Aproksymacja i trend liniowy


% Dokonanie aproksymacji trendu liniowego
x = 1:length(data.NoRefugees);
p = polyfit(x, data.NoRefugees, 1); % Dopasowanie trendu liniowego
trend = polyval(p, x); % Obliczenie wartości trendu dla danych

% Obliczenie błędu aproksymacji
error = norm(data.NoRefugees - trend) / sqrt(length(data.NoRefugees));

disp(['Błąd aproksymacji: ', num2str(error)]);

subplot(4, 3, 6);
plot(data.NoRefugees, 'b'); % Wykreślenie danych
hold on;
plot(trend, 'r--'); % Wykreślenie trendu liniowego
title('Trend liniowy');
xlabel('Indeks');
ylabel('Liczba uchodźców');
legend('Dane', 'Trend liniowy');
grid on;

% 3.

% Wygładzanie danych za pomocą średniej ruchomej
k_values = [5, 10, 15]; % Wartości k dla wygładzania
smoothed_data = zeros(size(data.NoRefugees));

hold on;

for i = 1:length(k_values)
    k = k_values(i);
    smoothed_data(:, i) = movmean(data.NoRefugees, k);
    
    % Wykres danych wygładzonych
    subplot(4, 3, 6+i);
    plot(data.RefugeesDate, smoothed_data(:, i), 'r-'); % Wykreślenie danych wygładzonych
    title(['Dane wygładzone - k = ', num2str(k)]);
    xlabel('Data');
    ylabel('Liczba uchodźców');
end

hold off;


% 4.

% Dokonanie aproksymacji trendu wielomianem stopnia 3
p3 = polyfit(x, data.NoRefugees, 3); % Dopasowanie wielomianu stopnia 3
trend_poly3 = polyval(p3, x); % Obliczenie wartości trendu dla danych z wielomianu stopnia 3

% Obliczenie reziduów
residuals = data.NoRefugees - trend_poly3;

% Narysowanie reziduów
subplot(4, 3, 12);
plot(residuals, 'b');
title('Rezidua');
xlabel('Indeks');
ylabel('Reszty');
grid on;

% Wykres danych i trendu wielomianu stopnia 3
subplot(4, 3, [10,11]);
plot(x, data.NoRefugees, 'b'); % Wykreślenie danych
hold on;
plot(x, trend_poly3, 'r'); % Wykreślenie trendu wielomianu stopnia 3
title('Dane i trend wielomianu stopnia 3');
xlabel('Indeks');
ylabel('Liczba uchodźców');
legend('Dane', 'Wielomian 3 stopnia');
grid on;




% 5.

% W porównaniu skuteczności metod w punktach 3 i 4:
% W punkcie 3, wygładzanie danych za pomocą metody średniej ruchomej dla różnych wartości stałych wygładzania (k = 5, 10, 15) pozwala na redukcję szumów i fluktuacji w danych, co prowadzi do bardziej gładkich wykresów. Efekt wygładzania jest widoczny na wykresach, gdzie dane wygładzone dla różnych wartości k są bardziej stabilne i mniej podatne na nagłe zmiany w porównaniu do danych oryginalnych.
% W punkcie 4, dokonanie aproksymacji danych z wykorzystaniem wielomianu stopnia 3 może prowadzić do niedokładnego odwzorowania trendu danych, zwłaszcza jeśli występują duże zmiany między punktami danych. Trend liniowy wielomianu stopnia 3 może nie być w stanie idealnie dopasować się do wszystkich punktów danych, co skutkuje pewnym stopniem błędu aproksymacji.
% Wnioskiem jest to, że metoda średniej ruchomej dla różnych wartości k (5, 10, 15) może być bardziej skuteczna w wygładzaniu danych i redukcji szumów w porównaniu do aproksymacji wielomianem stopnia 3, który może być mniej precyzyjny w odwzorowaniu trendu danych. Dlatego wybór odpowiedniej metody zależy od konkretnego przypadku i celu analizy danych.