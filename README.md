# Vavatech.ZUS.CrystalReports
Przykładowe raporty ze szkolenia Crystal Reports dla zaawansowanych

- Blog Crystal Reports
http://sulmar.blogspot.com

- Crystal Reports Viewer 
https://www.crystalreports.com/crystal-viewer/

- Grupa Crystal Reports
https://www.goldenline.pl/grupy/Komputery_Internet/crystal-reports/

- Funkcje Crystal Reports
Funkcje Crystal Reports.pdf


# Opcje

## Grupowanie

### Dostosowanie nazwy grupy
![](images/2019-05-30_1141.png)


## Optymalizacja

## Grupowanie po stronie serwera
![](images/2019-05-30_1035.png)

## Formatowanie

### Formatowanie wielokolumnowe
![](images/2019-05-30_1237.png)

### Wyrównywanie linii
![](images/2019-05-30_1220.png)

## Sekcje
### Sekcja przeźroczysta
![](images/2019-05-30_1216.png)

## Parametry

### Parametr zakresowy
![](images/2019-05-31_1057.png)

### Parametr wielowartościowy
![](images/2019-05-31_1129.png)


# Porady

## Power Shell
W celu wdrożenia szybkiej automatyzacji generowania raportów Crystal Reports można zastosować skrypt Power Shell.

*Plik cr.ps1*

~~~ bash

param([String[]] $filename, [Int32] $param0)

[reflection.assembly]::LoadWithPartialName('CrystalDecisions.Shared')
[reflection.assembly]::LoadWithPartialName('CrystalDecisions.CrystalReports.Engine')

$report = New-Object CrystalDecisions.CrystalReports.Engine.ReportDocument

$report.Load($filename)

$report.SetDatabaseLogon('username','password')

$report.SetParameterValue("param0", $param0)

$report.ExportToDisk("Excel", "c:\temp\report.xls")

$report.ExportToDisk("PortableDocFormat", "c:\temp\report.pdf")

~~~

## Słownie złotych - formatowanie

**Problem:**

Standardowa funkcja ToWords zamienia liczbę na słownie do postaci, która jest nieco inna niż stosowana na fakturach, *np. dziesięć tysięcy pięćset trzydzieści i xx / 100*

Zazwyczaj na fakturach stosowany jest następujący zapis: *dziesięć tysięcy pięćset trzydzieści 0/100*


**Rozwiązanie:**
Należy utworzyć formułę, która zamieni xx oraz pozostałe elementy na oczekiwany format:

*Funkcja Slownie*
~~~ crystal
replace(replace(replace(ToWords(10530.00), 'xx', '0'), " i ", " "), " / ", "/")
~~~

np.
dziesięć tysięcy pięćset trzydzieści 0/100




Można utworzyć również własną funkcję i wielokrotnie ją stosować:

1. Uruchom **Edytor Formuł**
1. Wybierz opcję **Report Custom Functions | New**
1. Wpisz formułę

*własna funkcja ToWordsEx*
~~~ crystal
Function (currencyVar amount)
replace(replace(replace(ToWords(amount), 'xx', '0'), " i ", " "), " / ", "/")
~~~

Od tej pory można jej używać w formułach:
~~~ crystal
ToWordsEx(10530.00)
~~~



