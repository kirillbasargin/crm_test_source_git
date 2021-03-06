﻿Перем ПроектПоГруппеПроектов;

Функция ПолучитьРеквизитыДокумента()
	РеквизитыДокумента = Новый Структура("ДанныеОЗаемщиках,ПервоначальныйВзносПроцент, СрокКредита1,СрокКредита2,СрокКредита3"
	, ДанныеОЗаемщиках.Выгрузить(), ПервоначальныйВзносПроцент, СрокКредита1, СрокКредита2, СрокКредита3);	
	
	Возврат РеквизитыДокумента;
КонецФункции

Функция ПолучитьРасчетныеШагиБанков()
	//ТЗВозврат = Новый ТаблицаЗначений;
	ЗЗапрос = Новый Запрос;
	ЗЗапрос.Текст  = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	                |	БанкиВидыКредита.Ссылка КАК Банк,
	                |	БанкиВидыКредита.ШагРасчетный КАК ШагРасчетный
	                |ИЗ
	                |	Справочник.Банки.ВидыКредита КАК БанкиВидыКредита
	                |ГДЕ
	                |	БанкиВидыКредита.ВидКредита = ЗНАЧЕНИЕ(Справочник.ВидыКредитов.ИпотечныйКредит)";
	Возврат ЗЗапрос.Выполнить().Выгрузить();
КонецФункции

Процедура РассчитатьНаСервере(СтопФакторы, ТаблицаДоступныеПрограммы, КорпусаИФазы) Экспорт
	
	ОсновнойБанк = СписокБанков.Найти(Истина, "Основной");
	ПроектПоГруппеПроектов = ОпределитьПроект();
	Если ОсновнойБанк<> Неопределено Тогда
		ОсновнойБанк = ОсновнойБанк.Банк;
	КонецЕсли;
	
	ДобавленныеВРучнуюБанки = СписокБанков.Выгрузить(Новый Структура("ДобавленВручную", Истина)).ВыгрузитьКолонку("Банк");
	
	РасчетыИндивидуальные = Расчеты.Выгрузить();
	РасчетыИндивидуальные.Очистить();
	Для Каждого Стр из Расчеты Цикл
		Если ДобавленныеВРучнуюБанки.Найти(Стр.Банк) <> Неопределено Тогда
			нСтр =РасчетыИндивидуальные.Добавить();
			ЗаполнитьЗначенияСвойств(нСтр, Стр);
		КонецЕсли;
	КонецЦикла;
		
	
	ДоступныеПрограммыИндивидуальные = ДоступныеПрограммы.Выгрузить();
	ДоступныеПрограммыИндивидуальные.Очистить();
	Для Каждого Стр из ДоступныеПрограммы Цикл
		Если ДобавленныеВРучнуюБанки.Найти(Стр.Банк) <> Неопределено Тогда
			нСтр = ДоступныеПрограммыИндивидуальные.Добавить();
			ЗаполнитьЗначенияСвойств(нСтр, Стр);
		КонецЕсли;
	КонецЦикла;
	
	Расчеты.Очистить();
	ДоступныеПрограммы.Очистить();	
	
	ПараметрыСхем = ПолучитьПараметрыСхемУсловийСтавки();
	РеквизитыДокумента = ПолучитьРеквизитыДокумента();
	РасчетныеШагиБанков = ПолучитьРасчетныеШагиБанков();	
	
	Для Каждого Стр Из СписокБанков Цикл
		Если НЕ Стр.Выбор Тогда
			Продолжить;
		КонецЕсли;
		
		ПроцентнаяСтавка = ОпределитьПроцентнуюСтавку(ПараметрыСхем, Стр.Банк);
		
		Для Каждого Срок Из ПроцентнаяСтавка Цикл
			
			Если Срок.Значение = 0 Тогда
				//Сообщить("Для банка " + Стр.Банк + " на срок "+ Срок.Длительность + " не определена процентная ставка!");
				Продолжить;
			КонецЕсли;
			
			//Определим номер корпуса из объекта строительства
			Отбор = Новый Структура("ОбъектСтроительства", Корпус);
			НС = КорпусаИФазы.НайтиСтроки(Отбор);
			Для Каждого НСтр Из НС Цикл
				НомерКорпуса = НСтр.НомерКорпуса;
				Прервать;
			КонецЦикла;
			//Проверка отборов
			ПроходитОтбор = СхемаПроходитОтбор(Срок.СхемаУсловийСтавок,НомерКорпуса);
			Если НЕ ПроходитОтбор Тогда
				Продолжить;	
			КонецЕсли;

			
			
			НовРасчет = Расчеты.Добавить();	
	        СтрШага = РасчетныеШагиБанков.Найти(Стр.Банк);
			ВыбранныйВидКредитаШагРасчетный = ?(СтрШага = Неопределено, 12, СтрШага.ШагРасчетный);
			
			НовРасчет.Банк = Стр.Банк;
			НовРасчет.СрокКредита = Срок.Длительность;
			НовРасчет.Сортировка = ?(НовРасчет.Банк = ОсновнойБанк, 0, 1);	
			НовРасчет.Программа = Срок.Программа;
			НовРасчет.СхемаУсловийСтавок = Срок.СхемаУсловийСтавок;
			НовРасчет.ПроцентнаяСтавка = Срок.Значение;	
			
			ПС = НовРасчет.ПроцентнаяСтавка/100/12; // ежемесячная процентная ставка
			Икс = POW(1+ПС,-(НовРасчет.СрокКредита-ВыбранныйВидКредитаШагРасчетный));	
			КПКД = ВернутьКПКД(Стр.Банк);
			Если КПКД = Неопределено ИЛИ КПКД = 0  Тогда
				Сообщить("Необходимо внести коэффициент платеж/доход для банка """ + Стр.Банк + """");
				Возврат;
			КонецЕсли;
					
			НовРасчет.СуммаПлатежа = ?(НовРасчет.ПроцентнаяСтавка=0,0,СуммаКредитаРуб*ПС/(1-Икс));
			НовРасчет.МинимальныйДоход = НовРасчет.СуммаПлатежа/КПКД;
			
			НовРасчет.СовокупныйДоход = ОпределитьСовокупныйДоход(НовРасчет.Банк, СтопФакторы);			
			Если НовРасчет.МинимальныйДоход> НовРасчет.СовокупныйДоход Тогда
				НовРасчет.Выбор = Ложь; 
				НовРасчет.Описание = "Совокупный доход заемщиков (" + НовРасчет.СовокупныйДоход + ") меньше минимально необходимого ("+ НовРасчет.МинимальныйДоход+")";
			Иначе
				НовРасчет.Выбор = Истина;
			КонецЕсли;
						
			НовРасчет = ДоступныеПрограммы.Добавить();
			НовРасчет.Банк = Стр.Банк;
			НовРасчет.Программа = Срок.Программа;
			НовРасчет.Выбор = Истина;

		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Стр Из ДоступныеПрограммыИндивидуальные Цикл
		нСтр = ДоступныеПрограммы.Добавить();
		ЗаполнитьЗначенияСвойств(нСтр, Стр);
	КонецЦикла;
	
	Для Каждого Стр Из РасчетыИндивидуальные Цикл
		нСтр = Расчеты.Добавить();
		ЗаполнитьЗначенияСвойств(нСтр, Стр);
	КонецЦикла;

	ДоступныеПрограммы.Свернуть("Банк, Программа, Выбор");
	ДополнитьРасчетыДопРасходами();
	Расчеты.Сортировать("Сортировка, ПроцентнаяСтавка, НомерСтроки Возр");

КонецПроцедуры

Процедура ДополнитьРасчетыДопРасходами()

	ЗЗапрос = Новый Запрос;
	ЗЗапрос.Текст = 
	"ВЫБРАТЬ
	|	вр.НомерСтроки КАК НомерСтроки,
	|	вр.ПорядокБанка КАК ПорядокБанка,
	|	вр.Банк КАК Банк,
	|	вр.СрокКредита КАК СрокКредита,
	|	вр.ПроцентнаяСтавка КАК ПроцентнаяСтавка,
	|	вр.СуммаПлатежа КАК СуммаПлатежа,
	|	вр.МинимальныйДоход КАК МинимальныйДоход,
	|	вр.Сортировка КАК Сортировка,
	|	вр.СовокупныйДоход КАК СовокупныйДоход,
	|	вр.Программа КАК Программа,
	|	вр.Выбор,
	|	вр.СхемаУсловийСтавок КАК СхемаУсловийСтавок,
	|	вр.Описание КАК Описание
	|ПОМЕСТИТЬ п1
	|ИЗ
	|	&Таблица КАК вр
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	п1.НомерСтроки КАК НомерСтроки,
	|	п1.Банк,
	|	п1.СрокКредита,
	|	п1.ПроцентнаяСтавка,
	|	п1.СуммаПлатежа,
	|	п1.МинимальныйДоход,
	|	п1.Сортировка КАК Сортировка,
	|	п1.СовокупныйДоход,
	|	п1.Программа,
	|	п1.СхемаУсловийСтавок,
	|	п1.Описание,
	|	УсловияИпотечногоКредитованияСрезПоследних.ДополнительныеРасходы КАК ДопРасходы,
	|	п1.Выбор,
	|	п1.ПорядокБанка КАК ПорядокБанка
	|ИЗ
	|	п1 КАК п1
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УсловияИпотечногоКредитования.СрезПоследних(&Дата, ) КАК УсловияИпотечногоКредитованияСрезПоследних
	|		ПО п1.Банк = УсловияИпотечногоКредитованияСрезПоследних.Банк
	|			И (УсловияИпотечногоКредитованияСрезПоследних.ВидКредита = &Ипотека)
	|			И (УсловияИпотечногоКредитованияСрезПоследних.Проект = &ГруппаПроектов)
	|			И п1.Программа = УсловияИпотечногоКредитованияСрезПоследних.Программа
	|			И (УсловияИпотечногоКредитованияСрезПоследних.ТипОбъекта = &ТипОбъекта)
	|
	|СГРУППИРОВАТЬ ПО
	|	п1.Сортировка,
	|	п1.СуммаПлатежа,
	|	п1.СовокупныйДоход,
	|	п1.ПроцентнаяСтавка,
	|	п1.НомерСтроки,
	|	п1.Программа,
	|	УсловияИпотечногоКредитованияСрезПоследних.ДополнительныеРасходы,
	|	п1.СрокКредита,
	|	п1.Выбор,
	|	п1.СхемаУсловийСтавок,
	|	п1.МинимальныйДоход,
	|	п1.Банк,
	|	п1.Описание,
	|	п1.ПорядокБанка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сортировка,
	|	ПорядокБанка,
	|	НомерСтроки";
	
	ЗЗапрос.УстановитьПараметр("Таблица", Расчеты.Выгрузить());
	ЗЗапрос.УстановитьПараметр("Ипотека", Справочники.ВидыКредитов.ИпотечныйКредит);
	ЗЗапрос.УстановитьПараметр("ГруппаПроектов", ЖК);
	ЗЗапрос.УстановитьПараметр("Дата", Дата);
	ЗЗапрос.УстановитьПараметр("ТипОбъекта", ТипОбъекта);


	РезультатЗапроса = ЗЗапрос.Выполнить().Выгрузить();
	Расчеты.Загрузить(РезультатЗапроса);
	
КонецПроцедуры

Функция ВернутьКПКД(Банк)
	
	ЗЗапрос = Новый Запрос;
	ЗЗапрос.Текст = 
		"ВЫБРАТЬ
		|	КоэффициентыПлатежДоходСрезПоследних.Коэффициент
		|ИЗ
		|	РегистрСведений.КоэффициентыПлатежДоход.СрезПоследних(&Дата, Банк = &Банк) КАК КоэффициентыПлатежДоходСрезПоследних";
	
	ЗЗапрос.УстановитьПараметр("Банк", Банк);
	ЗЗапрос.УстановитьПараметр("Дата", Дата);
	
	РезультатЗапроса = ЗЗапрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Коэффициент;
	КонецЦикла;
	
КонецФункции

Функция ОпределитьСовокупныйДоход(Банк, СтопФакторы)
	
	МассивИсключаемых = Новый Массив;
	Отбор = Новый Структура("Банк, РезультатГруппы",Банк, Ложь);
	ИсключаемыеСозаемщики = СтопФакторы.НайтиСтроки(Отбор);
	Для Каждого Стр Из ИсключаемыеСозаемщики Цикл
		МассивИсключаемых.Добавить(Стр.Созаемщик);
	КонецЦикла;
	
	СовокупныйДоход =0;
	Для i=0 По ДанныеОЗаемщиках.Количество()-1 Цикл
		Если МассивИсключаемых.Найти(i)=Неопределено Тогда
			СовокупныйДоход = СовокупныйДоход + ДанныеОЗаемщиках[i].РазмерЕжемесячногоДохода-ДанныеОЗаемщиках[i].ФинансовыеОбязательстваСумма;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СовокупныйДоход;
КонецФункции

Функция ПолучитьПараметрыСхемУсловийСтавки()
	
	ЗЗапрос = Новый Запрос;
	ЗЗапрос.Текст = 
		"ВЫБРАТЬ
		|	ИпотечныеСтавкиСрезПоследних.Период,
		|	ИпотечныеСтавкиСрезПоследних.Банк,
		|	ИпотечныеСтавкиСрезПоследних.Группа,
		|	ИпотечныеСтавкиСрезПоследних.Расположение,
		|	ИпотечныеСтавкиСрезПоследних.СхемаУсловийСтавок КАК СхемаУсловийСтавок,
		|	ИпотечныеСтавкиСрезПоследних.Параметр,
		|	ИпотечныеСтавкиСрезПоследних.Ставка,
		|	ИпотечныеСтавкиСрезПоследних.Активен,
		|	ИпотечныеСтавкиСрезПоследних.Тип КАК Тип,
		|	ИпотечныеСтавкиСрезПоследних.ПрограммаКредитования
		|ИЗ
		|	РегистрСведений.ИпотечныеСтавки.СрезПоследних(
		|			&Дата,
		|			Банк В (&СписокБанков)
		|				И (&Дата МЕЖДУ ПрограммаКредитования.НачалоДействия И ПрограммаКредитования.ОкончаниеДействия)) КАК ИпотечныеСтавкиСрезПоследних
		|ГДЕ
		|	ИпотечныеСтавкиСрезПоследних.Активен";
	
	ЗЗапрос.УстановитьПараметр("Дата", Дата);
	ЗЗапрос.УстановитьПараметр("СписокБанков", ВернутьСписокБанков());
	
	РезультатЗапроса = ЗЗапрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

Функция ПолучитьСроки()
	
	Сроки = Новый Массив;
	Если СрокКредита1<>0 Тогда
		Сроки.Добавить(СрокКредита1);
	КонецЕсли;
	Если СрокКредита2<>0 Тогда
		Сроки.Добавить(СрокКредита2);
	КонецЕсли;
	Если СрокКредита3<>0 Тогда
		Сроки.Добавить(СрокКредита3);
	КонецЕсли;
	
	Возврат Сроки;
КонецФункции

Функция ВернутьСписокБанков()
	
	Отбор = Новый Структура("Выбор", Истина);
	Банки = Новый Массив;
	Список = СписокБанков.НайтиСтроки(Отбор);
	Для Каждого Стр Из Список Цикл
	Банки.Добавить(Стр.Банк);
	КонецЦикла;
	Возврат Банки;

КонецФункции

Функция ОпределитьПроцентнуюСтавку(ПараметрыСхем, Банк)
	
 	Отбор = Новый Структура("Банк", Банк);
	ПараметрыБанка = ПараметрыСхем.НайтиСтроки(Отбор);
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Расположение");
	Таблица.Колонки.Добавить("Банк");
	Таблица.Колонки.Добавить("Группа");
	Таблица.Колонки.Добавить("Значение");
	Таблица.Колонки.Добавить("Ставка");
	Таблица.Колонки.Добавить("СхемаУсловийСтавок");
	Таблица.Колонки.Добавить("ПрограммаКредитования");

	
	СписокСхем = Новый Массив;
	
	Для Каждого Стр Из ПараметрыБанка Цикл
		ДобавитьЗначенияВТаблицу(Стр, Таблица);
		ДобавитьСхемуВСписок(Стр, СписокСхем);
	КонецЦикла;
	
	
	
	Сроки = ПолучитьСроки();
	Ставки = Новый Массив;
	
	Для Каждого Схема Из СписокСхем Цикл
		Для Каждого Срок Из Сроки Цикл
			Ставка = РазмерСтавки(Схема, Срок, Таблица);
			Ставки.Добавить(Новый Структура("Программа, СхемаУсловийСтавок,Длительность,Значение",Схема.Владелец, Схема, Срок,Ставка));	
		КонецЦикла;
	КонецЦикла;        
	
	Возврат Ставки;
	
КонецФункции

Процедура ДобавитьСхемуВСписок(Стр, СписокСхем)
	Если СписокСхем.Найти(Стр.СхемаУсловийСтавок) = Неопределено Тогда
		СписокСхем.Добавить(Стр.СхемаУсловийСтавок);
	КонецЕсли;
КонецПроцедуры

Функция РазмерСтавки(Схема, Срок, Таблица)
	
	Ставка = 0;
	ОтборПоСхеме = Новый Структура("СхемаУсловийСтавок", Схема);
	ЧастьТаблицы = Таблица.НайтиСтроки(ОтборПоСхеме);
	Для Каждого Стр Из ЧастьТаблицы Цикл
		МассивУсловий = Стр.Значение;
		Для Каждого Условие Из МассивУсловий Цикл
			Если Условие.Значение = Неопределено Тогда
				УсловиеВыполняется = Истина;
			ИначеЕсли Условие.Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.ПервоначальныйВзнос Тогда
				УсловиеВыполняется = ПервоначальныйВзносПроцент >=Условие.Значение.Минимум И ПервоначальныйВзносПроцент <Условие.Значение.Максимум;
			ИначеЕсли Условие.Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.СрокКредита Тогда
				УсловиеВыполняется = Срок >=Условие.Значение.Минимум И Срок <Условие.Значение.Максимум;	
			ИначеЕсли Условие.Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.ТипОбъекта Тогда
				УсловиеВыполняется = ТипОбъекта = Условие.Значение;	
			ИначеЕсли Условие.Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.Площадь Тогда
				УсловиеВыполняется = Площадь = Условие.Значение;	
			Иначе
				УсловиеВыполняется = СтопФакторПрисутствуетУЗаемщика(Условие.Значение, 0, Стр);
			КонецЕсли;
			Если НЕ УсловиеВыполняется Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если УсловиеВыполняется Тогда
			Ставка = Стр.Ставка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ставка;

	
КонецФункции

Процедура ДобавитьЗначенияВТаблицу(Стр, Таблица)
	
		Схема = Стр.СхемаУсловийСтавок;
		ЗначенияУсловий = Справочники.СхемыУсловийСтавки.ПолучитьЗначенияУсловий(Схема, Стр.Расположение, Стр.Параметр);
		Если ЗначенияУсловий = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ТипСтроки = Схема.Строки;
		ТипКолонки = Схема.Колонки;
		ЗначенияСтрокКолонок =  ПолучитьЗначениеПоТипу(ТипСтроки, ТипКолонки, ЗначенияУсловий.Значение.ЗначенияПересечения);

		Отбор = Новый Структура("Банк, Группа, Расположение, Ставка, СхемаУсловийСтавок, ПрограммаКредитования", Стр.Банк, Стр.Группа, Стр.Расположение, Стр.Ставка, Схема, Стр.ПрограммаКредитования);
		Найденное = Таблица.НайтиСтроки(Отбор);
		Если Найденное.Количество()=0 Тогда
			НовСтр = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, Отбор);
			НовСтр.Значение = Новый Структура("ЗначениеСтроки, ЗначениеКолонки", ЗначенияСтрокКолонок.ЗначениеСтроки, ЗначенияСтрокКолонок.ЗначениеКолонки);
			Если ЗначениеЗаполнено(Стр.Параметр) Тогда
				НовСтр.Значение.Вставить("Значение3", Стр.Параметр);
			КонецЕсли;
		Иначе
			Для Каждого НовСтр Из Найденное Цикл
				НовСтр.Значение.Вставить("Значение" + (НовСтр.Значение.Количество()+1), Стр.Параметр); 
			КонецЦикла;
		КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЗначениеПоТипу(ТипСтроки, ТипКолонки, ЗначенияПересечения)
	
	СтруктураВозврата = Новый Структура("ЗначениеКолонки, ЗначениеСтроки");
	
	Для Каждого Стр Из ЗначенияПересечения Цикл
		Если Стр.Владелец = ТипСтроки Тогда	
			СтруктураВозврата.Вставить("ЗначениеСтроки", Стр.Ссылка);
		ИначеЕсли 
			Стр.Владелец = ТипКолонки Тогда
			СтруктураВозврата.Вставить("ЗначениеКолонки", Стр.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция СтопФакторПрисутствуетУЗаемщика(Значение, НомерСозаемщика, СтрокаТаблицы) Экспорт
	
	Если Значение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДанныеЗаемщика = ДанныеОЗаемщиках[НомерСозаемщика];
	
	Если Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.Возраст Тогда
		Если ДанныеЗаемщика.КоличествоПолныхЛет > Значение.Минимум И ДанныеЗаемщика.КоличествоПолныхЛет <= Значение.Максимум Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.СуммаКредита Тогда
		Возврат СуммаКредитаРуб > Значение.Минимум И СуммаКредитаРуб <= Значение.Максимум;// Значение.Максимум > СуммаКредитаРуб > Значение.Минимум;

	ИначеЕсли Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.ВозрастНаМоментПогашенияКредита Тогда
		Возраст1 = ДанныеЗаемщика.КоличествоПолныхЛет+ СрокКредита1/12;
		Возраст2 = ДанныеЗаемщика.КоличествоПолныхЛет+ СрокКредита2/12;
		Возраст3 = ДанныеЗаемщика.КоличествоПолныхЛет+ СрокКредита3/12;		
		Если Возраст1> Значение.Минимум И Возраст1 <= Значение.Максимум
			И	 Возраст2> Значение.Минимум И Возраст2 <= Значение.Максимум
			И	 Возраст3> Значение.Минимум И Возраст3 <= Значение.Максимум Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли Значение.Владелец = ПланыВидовХарактеристик.ПараметрыПримененияСтавок.ЗарплатныйКлиент Тогда
		//"Да" с другим банком = "нет"
		ЗначениеСравнения = ?(Значение.Владелец.ЗначениеДа = ДанныеЗаемщика.НаличиеЗПКартыБанка И ДанныеЗаемщика.БанкЭмитент = СтрокаТаблицы.Банк, Значение.Владелец.ЗначениеДа, Значение.Владелец.ЗначениеНет);
		Возврат ЗначениеСравнения = Значение;
	КонецЕсли;

		
	ТЗ = ДанныеОЗаемщиках.Выгрузить();
	
	Для Каждого Колонка Из ТЗ.Колонки Цикл
		ИмяКолонки = Колонка.Имя;	
		ЗначениеУЗаемщика = ДанныеОЗаемщиках[НомерСозаемщика][ИмяКолонки];
		Если ЗначениеУЗаемщика= Значение Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция СхемаПроходитОтбор(Схема, НомерКорпуса) Экспорт
	Рез = Истина;
	МассивПВХ = Новый Массив;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Проект.Ссылка КАК Проект,
	|	Фазы.Ссылка КАК Фаза,
	|	&Корпус КАК Корпус,
	|	&Площадь КАК Площадь,
	|	&ТипОбъекта КАК ТипОбъекта
	|   //ДополнительныеПараметры
	|ИЗ
	|	Справочник.Фазы КАК Фазы
	|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.Проекты КАК Проект
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Проект.Ссылка = &Проект И Фазы.Ссылка = &Фаза";
	
	ДополнитьЗапросДаннымиПВХ(ТекстЗапроса, МассивПВХ);
	
	СхемаКомпоновки 							= Справочники.СхемыУсловийСтавки.СоздатьСхемуКомпоновкиОтборы();
	СхемаКомпоновки.НаборыДанных.Набор1.Запрос  = ТекстЗапроса;
	СхемаКомпоновки.Параметры.Очистить();

	ИсточникДоступныхНастроекКомпоновкиДанных		= Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки);
	КомпоновщикМакетаКомпоновкиДанных				= Новый КомпоновщикМакетаКомпоновкиДанных;	
	КомпоновщикНастроекКомпоновкиДанных 			= Новый КомпоновщикНастроекКомпоновкиДанных;
	
	НоваяГруппировка = КомпоновщикНастроекКомпоновкиДанных.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	НоваяГруппировка.Использование	= Истина;
	НоваяГруппировка.Имя			= "Проект";	
	
	ВыбранноеПолеГруппировки = НоваяГруппировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеГруппировки.Поле 			= Новый ПолеКомпоновкиДанных("Проект");
	ВыбранноеПолеГруппировки.Использование 	= Истина;
	
	Параметр = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Добавить();	
	Параметр.Параметр = Новый ПараметрКомпоновкиДанных("Проект");
	Параметр.Значение = ПроектПоГруппеПроектов;
	Параметр.Использование = Истина;
	
	Параметр = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Добавить();	
	Параметр.Параметр = Новый ПараметрКомпоновкиДанных("Фаза");
	Параметр.Значение = Фаза;
	Параметр.Использование = Истина;  
	
	Параметр = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Добавить();	
	Параметр.Параметр = Новый ПараметрКомпоновкиДанных("Корпус");
	Параметр.Значение = НомерКорпуса;
	Параметр.Использование = Истина;  
	
	Параметр = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Добавить();	
	Параметр.Параметр = Новый ПараметрКомпоновкиДанных("Площадь");
	Параметр.Значение = Площадь;
	Параметр.Использование = Истина; 
	
	Параметр = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Добавить();	
	Параметр.Параметр = Новый ПараметрКомпоновкиДанных("ТипОбъекта");
	Параметр.Значение = ТипОбъекта;
	Параметр.Использование = Истина; 
	
	//ПВХ
	Для Каждого Стр Из МассивПВХ Цикл	
	Параметр = КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.Элементы.Добавить();	
	Параметр.Параметр = Новый ПараметрКомпоновкиДанных(Стр);
	Параметр.Значение = ДанныеОЗаемщиках[0][Стр];
	Параметр.Использование = Истина;  
	КонецЦикла;
	
	КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы.Очистить();
	Если ЗначениеЗаполнено(Схема) Тогда 
		СкопироватьЭлементыОтбораРекурсивно(КомпоновщикНастроекКомпоновкиДанных.Настройки,  Схема.ХранилищеНастроекКомпоновкиДанныхОтборы.Получить());
	КонецЕсли;
	
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновки
	,КомпоновщикНастроекКомпоновкиДанных.Настройки, , ,
	Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных,,,Истина);
	ПроцессорВыводаВКоллекциюЗначений = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВыводаВКоллекциюЗначений.УстановитьОбъект(ТаблицаРезультат); 	
	ПроцессорВыводаВКоллекциюЗначений.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	Возврат ТаблицаРезультат.Количество()>0;
КонецФункции

Процедура СкопироватьЭлементыОтбораРекурсивно(Приемник, Источник) Экспорт
	
	Если Источник = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Приемник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
		ЭлементыПриемник = Приемник;
	Иначе
	ЭлементыПриемник = Приемник.Отбор;
	КонецЕсли;

	Если ТипЗнч(Источник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
		ЭлементыИсточник = Источник;
	Иначе
	ЭлементыИсточник = Источник.Отбор;
	КонецЕсли;
	
	ЭлементыПриемник.Элементы.Очистить();
	Для каждого ЭлементОтбора Из ЭлементыИсточник.Элементы Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			НовыйЭлемент = ЭлементыПриемник.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));	
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементОтбора);

			СкопироватьЭлементыОтбораРекурсивно(НовыйЭлемент, ЭлементОтбора);
		Иначе
			
			ПредставлениеОтбора = Строка(ЭлементОтбора.ЛевоеЗначение);
			Если Найти(ПредставлениеОтбора, "ПрограммируемыеУсловия") > 0 Тогда
				Продолжить;			
			КонецЕсли; 
				
			НовыйЭлемент = ЭлементыПриемник.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементОтбора);

		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры 

Процедура ДополнитьЗапросДаннымиПВХ(ТекстЗапроса, МассивПВХ)
	
	ТекстДополнения = "";
	ТаблицаДанныеОЗаемщиках = ДанныеОЗаемщиках.Выгрузить();
		
	ДанныеОЗаемщике = ТаблицаДанныеОЗаемщиках[0];
	ОписаниеТипаПВХ = Новый ОписаниеТипов("СправочникСсылка.ПараметрыПримененияСтавок_Значения");
	ТипЧисло = Тип("Число");
	
	Для Каждого Стр Из ТаблицаДанныеОЗаемщиках.Колонки Цикл
		Если ТипЗнч(ДанныеОЗаемщике[Стр.Имя]) = ТипЧисло Тогда
			Если Стр.Имя = "НомерСтроки" Тогда
				Продолжить;
			КонецЕсли;
			ТекстДополнения = ТекстДополнения + Символы.ПС + ", &" + Стр.Имя + " КАК " + Стр.Имя;
			МассивПВХ.Добавить(Стр.Имя);
		ИначеЕсли Стр.ТипЗначения = ОписаниеТипаПВХ Тогда
			УникальныйИдентификатор = СтрЗаменить(Строка(ДанныеОЗаемщике[Стр.Имя].Владелец.УникальныйИдентификатор()),"-","_");
			Поле = "Поле"+УникальныйИдентификатор;            
			ТекстДополнения = ТекстДополнения + Символы.ПС + ", &" + Стр.Имя + " КАК " + Поле;
			МассивПВХ.Добавить(Стр.Имя);
		КонецЕсли;
	КонецЦикла;
	
	//+Площадь
	Поле = "Поле"+ СтрЗаменить(ПланыВидовХарактеристик.ПараметрыПримененияСтавок.Площадь.УникальныйИдентификатор(),"-","_");
	ТекстДополнения = ТекстДополнения + Символы.ПС + ", &Площадь" + " КАК " + Поле;

	//+ТипОбъекта
	Поле = "Поле"+ СтрЗаменить(ПланыВидовХарактеристик.ПараметрыПримененияСтавок.ТипОбъекта.УникальныйИдентификатор(),"-","_");
	ТекстДополнения = ТекстДополнения + Символы.ПС + ", &ТипОбъекта" + " КАК " + Поле;

	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ДополнительныеПараметры", ТекстДополнения);
	
КонецПроцедуры

Процедура ОбработатьЧисловыеПоля(ИмяКолонки)
	
	Если ИмяКолонки= "НомерСтроки" Тогда
		Возврат;
	ИначеЕсли ИмяКолонки = "КоличествоПолныхЛет" Тогда
		
		
		
	КонецЕсли;	
	
КонецПроцедуры

Функция ОпределитьПроект()
	
	Если ТипЗнч(ЖК) = Тип("СправочникСсылка.Проекты") Тогда
		Возврат ЖК;
	КонецЕсли;
	
	ЗЗапрос = Новый Запрос;
	ЗЗапрос.Текст = "ВЫБРАТЬ
		|	МультикалькуляторГруппыПроектов.Проект
		|ИЗ
		|	РегистрСведений.МультикалькуляторГруппыПроектов КАК МультикалькуляторГруппыПроектов
		|ГДЕ
		|	МультикалькуляторГруппыПроектов.ГруппаПроектов = &ЖК
		|	И МультикалькуляторГруппыПроектов.Активен";
	
	ЗЗапрос.УстановитьПараметр("ЖК", ЖК);
	
	РезультатЗапроса = ЗЗапрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Проект;
	КонецЦикла;
	                         	
КонецФункции

//++ Юкаев Роман 20180119 (
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//ПараметрыИпотечнойЗаявки
	Движения.ПараметрыИпотечнойЗаявки.Записывать = Истина;
	Движения.ПараметрыИпотечнойЗаявки.Очистить();
	
	ПИЗ = Движения.ПараметрыИпотечнойЗаявки.Добавить();
	
	ЗаполнитьЗначенияСвойств(ПИЗ, Ссылка);
			
	ПИЗ.Проект = НайтиПроектПоГруппе(ЖК);
	ПИЗ.Период = Дата;
	
	ПИЗ.СписокБанков = ПолучитьСписокБанковСтрокой();
	ПИЗ.Заемщики = ПолучитьСписокЗаемщиковСтрокой();
	
	Если ДанныеОЗаемщиках.Количество() > 0 И ЗначениеЗаполнено(ДанныеОЗаемщиках[0].ФИО) Тогда
		ПИЗ.ОсновнойЗаемщик = ДанныеОЗаемщиках[0].ФИО;
	КонецЕсли;
	
	//ЗаемщикиИпотечнойЗаявки
	Если ДанныеОЗаемщиках.Количество() > 0 Тогда
		
		Движения.ЗаемщикиИпотечнойЗаявки.Записывать = Истина;
		Движения.ЗаемщикиИпотечнойЗаявки.Очистить();
		
		Для Каждого СтрокаТЧ Из ДанныеОЗаемщиках Цикл
			НоваяЗапись = Движения.ЗаемщикиИпотечнойЗаявки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТЧ);
			НоваяЗапись.ОсновнойЗаемщик = СтрокаТЧ.НомерСтроки = 1;
			НоваяЗапись.Клиент = СтрокаТЧ.ФИО;
			НоваяЗапись.Период = Дата;
		КонецЦикла;		
	КонецЕсли;
		
	//РасчетыИпотечнойЗаявки
	Если Расчеты.Количество() > 0 Тогда
		
		Движения.РасчетыИпотечнойЗаявки.Записывать = Истина;
		Движения.РасчетыИпотечнойЗаявки.Очистить();
		
		Для Каждого СтрокаТЧ Из Расчеты Цикл
			НоваяЗапись = Движения.РасчетыИпотечнойЗаявки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТЧ);
				
			НоваяЗапись.Период = Дата;
			НоваяЗапись.Выбранная = СтрокаТЧ.Выбор;
			НоваяЗапись.Запрос = Запрос;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСписокБанковСтрокой()
	
	БанкиСтрокой = "";
	
	Банки = Расчеты.Выгрузить(, "Банк");
	Банки.Свернуть("Банк");
	
	Для Каждого СтрокаТЧ Из Банки Цикл
		БанкиСтрокой = БанкиСтрокой + Строка(СтрокаТЧ.Банк) + "; ";
	КонецЦикла;
	
	Возврат Сред(БанкиСтрокой, 1, СтрДлина(БанкиСтрокой) - 2);
	
КонецФункции

Функция ПолучитьСписокЗаемщиковСтрокой()
	
	ЗаемщикиСтрокой = "";
	Заемщики = ДанныеОЗаемщиках.Выгрузить(, "ФИО");
	Заемщики.Свернуть("ФИО");
	
	Для Каждого СтрокаТЧ Из Заемщики Цикл
		ЗаемщикиСтрокой = ЗаемщикиСтрокой + Строка(СтрокаТЧ.ФИО) + "; ";
	КонецЦикла;
	
	Возврат Сред(ЗаемщикиСтрокой, 1, СтрДлина(ЗаемщикиСтрокой) - 2);
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Стр Из ДанныеОЗаемщиках Цикл
		
		Если Стр.ФИО = Справочники.Клиенты.ПустаяСсылка() Тогда
			
			ТекстСообщения = "Не указано ФИО ";
			Если Стр.НомерСтроки = 1 Тогда
				ТекстСообщения = ТекстСообщения + "Заемщика";
				Сообщить(ТекстСообщения);
				Отказ = Истина;
			Иначе
				//ТекстСообщения = ТекстСообщения + "Созаемщика " + Строка(Стр.НомерСтроки - 1);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Запрос") Тогда
		ДокументОснование = ДанныеЗаполнения.Запрос;
		Заполнять = ЗначениеЗаполнено(ДокументОснование);
		Ответственный = Пользователи.ТекущийПользователь();
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Запрос") Тогда
		ДокументОснование = ДанныеЗаполнения;
		Заполнять = ЗначениеЗаполнено(ДокументОснование);
	Иначе
		Заполнять = Ложь;
	КонецЕсли;
	
	Если Заполнять Тогда
		
		ЖК = ДокументОснование.Проект;
		
		Если ДокументОснование.СписокОбъектовСтроительства.Количество() = 1 Тогда
			Корпус = ДокументОснование.СписокОбъектовСтроительства[0].ОбъектСтроительства;
		КонецЕсли;
		
		Если ДокументОснование.Фазы.Количество() = 1 Тогда
			Фаза = ДокументОснование.Фазы[0].Фаза;
		КонецЕсли;
		
		Запрос = ДокументОснование;
		Ответственный = Пользователи.ТекущийПользователь();
		
		Если ЗначениеЗаполнено(ДокументОснование.Клиент) Тогда
			
			НовыйЗаемщик = ДанныеОЗаемщиках.Добавить();
			НовыйЗаемщик.ФИО = ДокументОснование.Клиент;
			
			ПараметрыПоФИО = ПолучитьПараметрыПоФИО(НовыйЗаемщик.ФИО);
				
			НовыйЗаемщик.Пол = ПараметрыПоФИО.Пол;
			НовыйЗаемщик.ДатаРождения = ПараметрыПоФИО.ДатаРождения;
			НовыйЗаемщик.КоличествоПолныхЛет = ПараметрыПоФИО.ПолныхЛет;
			НовыйЗаемщик.РегистрацияРФ = ПараметрыПоФИО.РегистрацияРФ;
			НовыйЗаемщик.ГражданствоРФ = ПараметрыПоФИО.ГражданствоРФ;
		ИначеЕсли ЗначениеЗаполнено(ДанныеЗаполнения.ФИО) Тогда
			
			НовыйЗаемщик = ДанныеОЗаемщиках.Добавить();
			НовыйЗаемщик.ФИО = ДанныеЗаполнения.ФИО;
			
			ПараметрыПоФИО = ПолучитьПараметрыПоФИО(НовыйЗаемщик.ФИО);
				
			НовыйЗаемщик.Пол = ПараметрыПоФИО.Пол;
			НовыйЗаемщик.ДатаРождения = ПараметрыПоФИО.ДатаРождения;
			НовыйЗаемщик.КоличествоПолныхЛет = ПараметрыПоФИО.ПолныхЛет;
			НовыйЗаемщик.РегистрацияРФ = ПараметрыПоФИО.РегистрацияРФ;
			НовыйЗаемщик.ГражданствоРФ = ПараметрыПоФИО.ГражданствоРФ;
		КонецЕсли;
		
		СтоимостьКвартирыРуб = ДокументОснование.ИмеющиесяНаличныеСредства;
		ПервоначальныйВзносРуб = ДокументОснование.ОбъемСредствНаПокупку;
		
		Если СтоимостьКвартирыРуб = 0 Тогда
			ПервоначальныйВзносПроцент = 0;
		Иначе
			ПервоначальныйВзносПроцент = Окр(100 * ПервоначальныйВзносРуб / СтоимостьКвартирыРуб, 2);
		КонецЕсли;
		
		СуммаКредитаРуб = СтоимостьКвартирыРуб - ПервоначальныйВзносРуб;
	Иначе
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ФИО") Тогда
			
			НовыйЗаемщик = ДанныеОЗаемщиках.Добавить();
			НовыйЗаемщик.ФИО = ДанныеЗаполнения.ФИО;
			
			Если ЗначениеЗаполнено(ДанныеЗаполнения.ФИО) Тогда
				ПараметрыПоФИО = ПолучитьПараметрыПоФИО(НовыйЗаемщик.ФИО);
				
				НовыйЗаемщик.Пол = ПараметрыПоФИО.Пол;
				НовыйЗаемщик.ДатаРождения = ПараметрыПоФИО.ДатаРождения;
				НовыйЗаемщик.КоличествоПолныхЛет = ПараметрыПоФИО.ПолныхЛет;
				НовыйЗаемщик.РегистрацияРФ = ПараметрыПоФИО.РегистрацияРФ;
				НовыйЗаемщик.ГражданствоРФ = ПараметрыПоФИО.ГражданствоРФ;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция ОпределитьЧислоПолныхЛет(ЗначениеРеквизита)
	
	Дата1 = ЗначениеРеквизита; 
	Дата2 = ТекущаяДата(); 
	
	ЧислоЛет = Год(Дата2) - Год(Дата1); 
	Если Месяц(Дата2) < Месяц(Дата1) Тогда 
		ЧислоЛет = ЧислоЛет-1; 
	ИначеЕсли Месяц(Дата2) = Месяц(Дата1) И День(Дата2) < День(Дата1) Тогда 
		ЧислоЛет = ЧислоЛет-1; 
	КонецЕсли; 
	
	Возврат ЧислоЛет;

КонецФункции

Функция НайтиОбъектСтроительства(Проект, Фаза, Корпус)
	
	ЗапросТ = Новый Запрос;
	ЗапросТ.Текст = 
		"ВЫБРАТЬ
		|	ОбъектыСтроительства.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ОбъектыСтроительства КАК ОбъектыСтроительства
		|ГДЕ
		|	ОбъектыСтроительства.Проект = &Проект
		|	И ОбъектыСтроительства.Корпус = &Корпус
		|	И ОбъектыСтроительства.Фаза = &Фаза";
	
	ЗапросТ.УстановитьПараметр("Корпус", Корпус);
	ЗапросТ.УстановитьПараметр("Проект", Проект);
	ЗапросТ.УстановитьПараметр("Фаза", Фаза);
	
	Результат = ЗапросТ.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.ОбъектыСтроительства.ПустаяСсылка();
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
КонецФункции

Функция НайтиПроектПоГруппе(Группа)
	
	Если ТипЗнч(Группа) = Тип("СправочникСсылка.Проекты") Тогда
		Возврат Группа;
	КонецЕсли;
	
	ЗапросТ = Новый Запрос;
	ЗапросТ.Текст = 
		"ВЫБРАТЬ
		|	МультикалькуляторГруппыПроектов.Проект КАК Проект
		|ИЗ
		|	РегистрСведений.МультикалькуляторГруппыПроектов КАК МультикалькуляторГруппыПроектов
		|ГДЕ
		|	МультикалькуляторГруппыПроектов.ГруппаПроектов = &ГруппаПроектов
		|	И МультикалькуляторГруппыПроектов.Активен";
	
	ЗапросТ.УстановитьПараметр("ГруппаПроектов", Группа);
	
	Результат = ЗапросТ.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.Проекты.ПустаяСсылка();
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Проект;
	КонецЕсли;
	
КонецФункции

Функция НайтиКорпус(ОС)
	
	ЗапросТ = Новый Запрос;
	ЗапросТ.Текст = 
		"ВЫБРАТЬ
		|	ОбъектыСтроительства.Корпус КАК Корпус
		|ИЗ
		|	Справочник.ОбъектыСтроительства КАК ОбъектыСтроительства
		|ГДЕ
		|	ОбъектыСтроительства.Ссылка = &Ссылка";
	
	ЗапросТ.УстановитьПараметр("Ссылка", ОС);
	
	Результат = ЗапросТ.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.КорпусаОбъектовСтроительства.ПустаяСсылка();
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Корпус;
	КонецЕсли;
	
КонецФункции

Процедура ПриЗаписи(Отказ)
	
	ИпотекаСервер.ОбновитьСтатусВРегистреИпотечныйСтатусКлиента(Ссылка, Запрос);
	
КонецПроцедуры

Функция ПолучитьПараметрыПоФИО(ТекущийЗаемщик)
	
	СписокПараметров = Новый Структура("Пол, ДатаРождения, ПолныхЛет, ГражданствоРФ, РегистрацияРФ");
	
	СписокПараметров.ДатаРождения = ТекущийЗаемщик.ДатаРождения;
	СписокПараметров.ПолныхЛет = ОпределитьЧислоПолныхЛет(ТекущийЗаемщик.ДатаРождения);
	
	ЗапросФ = Новый Запрос;
	ЗапросФ.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПараметрыПримененияСтавок.Ссылка КАК Ссылка,
		|	ПараметрыПримененияСтавок.Наименование КАК Наименование,
		|	ВЫБОР
		|		КОГДА ПараметрыПримененияСтавок.Наименование = ""Мужской""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский)
		|	КОНЕЦ КАК Значение,
		|	1 КАК Таблица
		|ИЗ
		|	Справочник.ПараметрыПримененияСтавок_Значения КАК ПараметрыПримененияСтавок
		|ГДЕ
		|	ПараметрыПримененияСтавок.Владелец = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПараметрыПримененияСтавок.Пол)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПараметрыПримененияСтавок.Ссылка,
		|	ПараметрыПримененияСтавок.Наименование,
		|	ВЫБОР
		|		КОГДА ПараметрыПримененияСтавок.Наименование = ""Да""
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	2
		|ИЗ
		|	Справочник.ПараметрыПримененияСтавок_Значения КАК ПараметрыПримененияСтавок
		|ГДЕ
		|	ПараметрыПримененияСтавок.Владелец = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПараметрыПримененияСтавок.ГражданствоРФ)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПараметрыПримененияСтавок.Ссылка,
		|	ПараметрыПримененияСтавок.Наименование,
		|	ВЫБОР
		|		КОГДА ПараметрыПримененияСтавок.Наименование = ""Да""
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	3
		|ИЗ
		|	Справочник.ПараметрыПримененияСтавок_Значения КАК ПараметрыПримененияСтавок
		|ГДЕ
		|	ПараметрыПримененияСтавок.Владелец = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПараметрыПримененияСтавок.РегистрацияРФ)";
	
	Результат = ЗапросФ.Выполнить();
	                                                                       
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выгрузка = Результат.Выгрузить();
		
		//Пол
		Значение = Выгрузка.НайтиСтроки(Новый Структура("Значение, Таблица", ТекущийЗаемщик.Пол, 1));
		Если Значение.Количество() > 0 Тогда
			Если ЗначениеЗаполнено(Значение[0].Ссылка) Тогда
				СписокПараметров.Пол = Значение[0].Ссылка;
			Иначе
				СписокПараметров.Пол = Справочники.ПараметрыПримененияСтавок_Значения.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
		
		//Гражданство
		Значение = Выгрузка.НайтиСтроки(Новый Структура("Значение, Таблица", ПолучитьГражданство(ТекущийЗаемщик), 2));
		Если Значение.Количество() > 0 Тогда
			Если ЗначениеЗаполнено(Значение[0].Ссылка) Тогда
				СписокПараметров.ГражданствоРФ = Значение[0].Ссылка;
			Иначе
				СписокПараметров.ГражданствоРФ = Справочники.ПараметрыПримененияСтавок_Значения.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
		
		//Регистрация
		Значение = Выгрузка.НайтиСтроки(Новый Структура("Значение, Таблица", ПолучитьРегистрацию(ТекущийЗаемщик), 3));
		
		Если Значение.Количество() > 0 Тогда
			Если ЗначениеЗаполнено(Значение[0].Ссылка) Тогда
				СписокПараметров.РегистрацияРФ = Значение[0].Ссылка;
			Иначе
				СписокПараметров.РегистрацияРФ = Справочники.ПараметрыПримененияСтавок_Значения.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
		
		Возврат СписокПараметров;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьГражданство(ТекущийЗаемщик)
	
	ЗапросГ = Новый Запрос;
	ЗапросГ.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ГражданствоФизическихЛицСрезПоследних.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Гражданство
		|ИЗ
		|	РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних(&Период, ФизическоеЛицо = &Клиент) КАК ГражданствоФизическихЛицСрезПоследних";
	
	ЗапросГ.УстановитьПараметр("Клиент", ТекущийЗаемщик);
	ЗапросГ.УстановитьПараметр("Период", ТекущаяДата());
	
	Результат = ЗапросГ.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Гражданство;
	КонецЕсли;
		
КонецФункции

Функция ПолучитьРегистрацию(ТекущийЗаемщик)
	
	ЗапросР = Новый Запрос;
	ЗапросР.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА КлиентыКонтактнаяИнформация.Страна = ""РОССИЯ""
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Регистрация
		|ИЗ
		|	Справочник.Клиенты.КонтактнаяИнформация КАК КлиентыКонтактнаяИнформация
		|ГДЕ
		|	КлиентыКонтактнаяИнформация.Ссылка = &Клиент
		|	И КлиентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
		|	И КлиентыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресПоПропискеКлиента)";
	
	ЗапросР.УстановитьПараметр("Клиент", ТекущийЗаемщик);
	
	Результат = ЗапросР.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Регистрация;
	КонецЕсли;
	
КонецФункции

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОбъектКопирования);
	СписокБанков.Очистить();
	Расчеты.Очистить();
	ДоступныеПрограммы.Очистить();
	СтопФакторы.Очистить();
	ПереченьДокументов.Очистить();
	
КонецПроцедуры

//-- Юкаев Роман 20180119 )