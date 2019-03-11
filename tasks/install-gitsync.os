#Использовать gitrunner
#Использовать tempfiles
#Использовать fs

Перем Лог;

Процедура ПолучитьИсходники(Знач URLРепозитория, Знач Ветка, Знач Каталог)

	ГитРепозиторий = Новый ГитРепозиторий;

	ГитРепозиторий.УстановитьРабочийКаталог(Каталог);

	ГитРепозиторий.КлонироватьРепозиторий(URLРепозитория, Каталог);
	ГитРепозиторий.ПерейтиВВетку(Ветка);

КонецПроцедуры

Процедура УстановитьПакет(Знач Каталог, ПутьКМанифестуСборки)
	
	Лог.Информация("Каталог сборки <%1>", Каталог);

	Лог.Информация("Сборка пакета библиотеки");
	КомандаOpm = Новый Команда;
	КомандаOpm.УстановитьРабочийКаталог(Каталог);
	КомандаOpm.УстановитьКоманду("opm");
	КомандаOpm.ДобавитьПараметр("build");	
	КомандаOpm.ДобавитьПараметр("--mf");	
	КомандаOpm.ДобавитьПараметр(ПутьКМанифестуСборки);	
	КомандаOpm.ДобавитьПараметр(Каталог);	
	КомандаOpm.ДобавитьЛогВыводаКоманды("task.install-opm");

	КодВозврата = КомандаOpm.Исполнить();

	Если КодВозврата <> 0  Тогда
		ВызватьИсключение КомандаOpm.ПолучитьВывод();
	КонецЕсли;

	МассивФайлов = НайтиФайлы(Каталог, "*.ospx");

	Если МассивФайлов.Количество() = 0 Тогда
		ВызватьИсключение Новый ИнформацияОбОшибке("Ошибка создания пакета gitsync", "Не найден собранный файл пакета gitsync");
	КонецЕсли;

	ФайлПлагина = МассивФайлов[0].ПолноеИмя;

	КаталогПроектаGitsync = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "bin");

	ФС.ОбеспечитьКаталог(КаталогПроектаGitsync);

	Лог.Информация("Установка в каталог проекта <%1>", КаталогПроектаGitsync);

	Лог.Информация("Установка пакета из файла <%1>", ФайлПлагина);

	КомандаOpm = Новый Команда;
	КомандаOpm.УстановитьРабочийКаталог(КаталогПроектаGitsync);
	КомандаOpm.УстановитьКоманду("opm");
	КомандаOpm.ДобавитьПараметр("install");	
	КомандаOpm.ДобавитьПараметр("-f");	
	КомандаOpm.ДобавитьПараметр(ФайлПлагина);
	КомандаOpm.ДобавитьПараметр("--dest");	
	КомандаOpm.ДобавитьПараметр(КаталогПроектаGitsync);	
	КомандаOpm.ДобавитьЛогВыводаКоманды("task.install-opm");

	КодВозврата = КомандаOpm.Исполнить();

	Если КодВозврата <> 0  Тогда
		ВызватьИсключение СтрШаблон("Ошибка установки opm из <%1> по причине <%2>", ФайлПлагина, КомандаOpm.ПолучитьВывод());
	КонецЕсли;

КонецПроцедуры

Процедура ПолезнаяРабота()

	URLРепозитория = "https://github.com/oscript-library/gitsync.git";
	КаталогСборки = ВременныеФайлы.СоздатьКаталог();
	Ветка = "develop";

	ПутьКМанифестуСборки = "build_packagedef";

	ПолучитьИсходники(URLРепозитория, Ветка, КаталогСборки);
	УстановитьПакет(КаталогСборки, ПутьКМанифестуСборки);

	ВременныеФайлы.УдалитьФайл(КаталогСборки);

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("task.install-opm");

ПолезнаяРабота();

