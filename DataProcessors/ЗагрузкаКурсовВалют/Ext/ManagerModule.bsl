﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Добавляет в справочник валют валюты из классификатора.
//
// Параметры:
//   Коды - Массив - цифровые коды добавляемых валют.
//
// Возвращаемое значение:
//   Массив, СправочникСсылка.Валюты - ссылки созданных валют.
//
Функция ДобавитьВалютыПоКоду(Знач Коды) Экспорт
	Перем КлассификаторXML, КлассификаторТаблица, ЗаписьОКВ, НоваяСтрока, Результат;
	КлассификаторXML = ПолучитьМакет("ОбщероссийскийКлассификаторВалют").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Результат = Новый Массив();
	
	Для каждого Код Из Коды Цикл
		ЗаписьОКВ = КлассификаторТаблица.Найти(Код, "Code"); 
		Если ЗаписьОКВ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВалютаСсылка = Справочники.Валюты.НайтиПоКоду(ЗаписьОКВ.Code);
		Если ВалютаСсылка.Пустая() Тогда
			НоваяСтрока = Справочники.Валюты.СоздатьЭлемент();
			НоваяСтрока.Код = ЗаписьОКВ.Code;
			НоваяСтрока.Наименование = ЗаписьОКВ.CodeSymbol;
			НоваяСтрока.НаименованиеПолное = ЗаписьОКВ.Name;
			Если ЗаписьОКВ.RBCLoading Тогда
				НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
			Иначе
				НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
			КонецЕсли;
			НоваяСтрока.ПараметрыПрописи = ЗаписьОКВ.NumerationItemOptions;
			НоваяСтрока.Записать();
			Результат.Добавить(НоваяСтрока.Ссылка);
		Иначе
			Результат.Добавить(ВалютаСсылка);
		КонецЕсли
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

// Загружает курсы валют на текущую дату.
//
// Параметры:
//  ПараметрыЗагрузки - Структура - детали загрузки:
//   * НачалоПериода - Дата - начало периода загрузки;
//   * КонецПериода - Дата - конец периода загрузки;
//   * СписокВалют - ТаблицаЗначений - загружаемые валюты:
//     ** Валюта - СправочникСсылка.Валюты;
//     ** КодВалюты - Строка.
//  АдресРезультата - Строка - адрес во временном хранилище для помещения результатов загрузки.
//
Процедура ЗагрузитьАктуальныйКурс(ПараметрыЗагрузки = Неопределено, АдресРезультата = Неопределено) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют);
	
	ИмяСобытия = ИмяСобытияЖурналаРегистрации();
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru = 'Начата регламентная загрузка курсов валют'"));
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	СостояниеЗагрузки = Неопределено;
	ПриЗагрузкеВозниклиОшибки = Ложь;
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КурсыВалют.Валюта КАК Валюта,
		|	КурсыВалют.Валюта.Код КАК КодВалюты,
		|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
		|ИЗ
		|	РегистрСведений.КурсыВалют КАК КурсыВалют
		|ГДЕ
		|	КурсыВалют.Валюта.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
		|	И НЕ КурсыВалют.Валюта.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	КурсыВалют.Валюта,
		|	КурсыВалют.Валюта.Код";
		Запрос = Новый Запрос(ТекстЗапроса);
		Выборка = Запрос.Выполнить().Выбрать();
		
		КонецПериода = ТекущаяДата;
		Пока Выборка.Следующий() Цикл
			НачалоПериода = ?(Выборка.ДатаКурса = '198001010000', НачалоГода(ДобавитьМесяц(ТекущаяДата, -12)), Выборка.ДатаКурса + 60*60*24);
			СписокВалют = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка);
			ЗагрузитьКурсыВалютПоПараметрам(СписокВалют, НачалоПериода, КонецПериода, ПриЗагрузкеВозниклиОшибки);
		КонецЦикла;
	Иначе
		Результат = ЗагрузитьКурсыВалютПоПараметрам(ПараметрыЗагрузки.СписокВалют,
			ПараметрыЗагрузки.НачалоПериода, ПараметрыЗагрузки.КонецПериода, ПриЗагрузкеВозниклиОшибки);
	КонецЕсли;
		
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;

	Если ПриЗагрузкеВозниклиОшибки Тогда
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			, 
			,
			НСтр("ru = 'Во время регламентного задания загрузки курсов валют возникли ошибки'"));
		ВызватьИсключение НСтр("ru = 'Загрузка курсов не выполнена.'");
	Иначе
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Информация,
			,
			,
			НСтр("ru = 'Завершена регламентная загрузка курсов валют.'"));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список разрешений для загрузки классификатора банков с сайта 1С.
//
// Параметры:
//  Разрешения - Массив - коллекция разрешений.
//
Процедура ДобавитьРазрешения(Разрешения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКурсовВалют.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Если ИспользоватьАльтернативныйСервер Тогда
		Протокол = "HTTP";
		Адрес = "cbrates.rbc.ru";
		Порт = Неопределено;
		Описание = НСтр("ru = 'Загрузка курсов валют с сайта РБК.'");
		Разрешения.Добавить( 
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	Иначе
		Протокол = "HTTPS";
		Адрес = "bankregister.1c.ru";
		Порт = Неопределено;
		Описание = НСтр("ru = 'Загрузка курсов валют с сайта 1С.'");
		Разрешения.Добавить( 
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	КонецЕсли;
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.9";
	Обработчик.Процедура = "Обработки.ЗагрузкаКурсовВалют.ОбновитьФорматХраненияПрописи";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.4.1.1";
	Обработчик.Процедура = "Обработки.ЗагрузкаКурсовВалют.ОтключитьЗагрузкуКурсаВалюты643ИзИнтернета";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("dc79c561-8657-4852-bbc5-38ced6996fff");
	Обработчик.Комментарий = НСтр("ru = 'Отключает ошибочно включенную загрузку курсов валюты ""Российский рубль (643)"" из интернета.'");
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Обработки.ЗагрузкаКурсовВалют.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ЧитаемыеОбъекты      = "Справочник.Валюты";
	Обработчик.ИзменяемыеОбъекты    = "Справочник.Валюты";
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "2.4.1.1";
		Обработчик.Процедура = "Обработки.ЗагрузкаКурсовВалют.УстановитьРасписаниеРегламентногоЗадания";
		Обработчик.РежимВыполнения = "Оперативно";
		Обработчик.НачальноеЗаполнение = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
// Параметры:
//  Параметры - Структура - служебный параметр для передачи в процедуру ОбновлениеИнформационнойБазы.ОтметитьКОбработке.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Код = ""643""
	|	И Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Зависимости) Экспорт
	Зависимость = Зависимости.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют;
	Зависимость.ДоступноВМоделиСервиса = Ложь;
	Зависимость.ДоступноВАвтономномРабочемМесте = Ложь;
КонецПроцедуры

// Устанавливает признак загрузки курсов из интернета по данным классификатора.
Процедура ПреобразованиеСвязейВалют() Экспорт
	Перем Запрос, Выборка, НаборЗаписей, Запись;
	Перем КлассификаторXML, КлассификаторТаблица, Валюта, НайденнаяСтрока;
	
	КлассификаторXML = Обработки["ЗагрузкаКурсовВалют"].ПолучитьМакет("ОбщероссийскийКлассификаторВалют").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	КлассификаторТаблица.Индексы.Добавить("Code");
	
	Выборка = Справочники.Валюты.Выбрать();
	Пока Выборка.Следующий()  Цикл
		Валюта = Выборка.ПолучитьОбъект();
		НайденнаяСтрока = КлассификаторТаблица.Найти(Валюта.Код, "Code");
		Если НайденнаяСтрока <> Неопределено И НайденнаяСтрока.RBCLoading = "истина" Тогда
			Валюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Валюта);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Процедура для загрузки курсов валют по определенному периоду.
//
// Параметры:
// Валюты		- Любая коллекция - со следующими полями:
//					КодВалюты - числовой код валюты.
//					Валюта - ссылка на валюту.
// НачалоПериодаЗагрузки	- Дата - начало периода загрузки курсов.
// ОкончаниеПериодаЗагрузки	- Дата - окончание периода загрузки курсов.
//
// Возвращаемое значение:
// Массив состояния загрузки  - каждый элемент - структура с полями.
//		Валюта - загружаемая валюта.
//		СтатусОперации - завершилась ли загрузка успешно.
//		Сообщение - пояснение о загрузке (текст сообщения об ошибке или поясняющее сообщение).
//
Функция ЗагрузитьКурсыВалютПоПараметрам(Знач Валюты, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки, ПриЗагрузкеВозниклиОшибки = Ложь)
	
	СостояниеЗагрузки = Новый Массив;
	
	ПараметрыПолучения = Неопределено;
	ИмяФайлаДневногоКурса = Формат(ОкончаниеПериодаЗагрузки, "ДФ=/yyyy/MM/dd");
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКурсовВалют.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИспользоватьАльтернативныйСервер Тогда
		СерверИсточник = "http://cbrates.rbc.ru";
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ШаблонИмениФайла = СерверИсточник + "/tsv/%1" + ИмяФайлаДневногоКурса + ".tsv";
		Иначе
			ШаблонИмениФайла = СерверИсточник + "/tsv/cb/%1.tsv";
		КонецЕсли;
	Иначе
		СерверИсточник = "https://currencyrates.1c.ru/exchangerate/v1";
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ШаблонИмениФайла = СерверИсточник + "/%1" + ИмяФайлаДневногоКурса + ".tsv";
		Иначе
			ШаблонИмениФайла = СерверИсточник + "/%1.tsv";
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		ПараметрыПолучения = ПараметрыАутентификацииНаСайте();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ВалютыЗагружаемыеИзИнтернета = ВалютыЗагружаемыеИзИнтернета();
	
	Для Каждого Валюта Из Валюты Цикл
		Если ВалютыЗагружаемыеИзИнтернета.Найти(Валюта.Валюта) = Неопределено Тогда
			ПриЗагрузкеВозниклиОшибки = Истина;
			СтатусОперации = Ложь;
			ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно получить файл данных с курсами валюты (%1 - %2):
					|Курсы данной валюты не предоставляются.'"),
				Валюта.КодВалюты,
				Валюта.Валюта);
				
			ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , , ПоясняющееСообщение);
		Иначе
			ФайлНаВебСервере = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла, Валюта.КодВалюты);
			Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере, ПараметрыПолучения);
			
			Если Результат.Статус Тогда
				ПоясняющееСообщение = ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
				УдалитьФайлы(Результат.Путь);
				СтатусОперации = ПустаяСтрока(ПоясняющееСообщение);
			Иначе
				ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Невозможно получить файл данных с курсами валюты (%1 - %2):
						|%3
						|Возможно, нет доступа к веб сайту с курсами валют, либо указана несуществующая валюта.'"),
					Валюта.КодВалюты,
					Валюта.Валюта,
					Результат.СообщениеОбОшибке);
				СтатусОперации = Ложь;
				ПриЗагрузкеВозниклиОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
		СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, СтатусОперации, ПоясняющееСообщение));
		
	КонецЦикла;
	
	Возврат СостояниеЗагрузки;
	
КонецФункции

// Загружает информацию о курсе валюты Валюта из файла ПутьКФайлу в регистр
// сведений курсов валют. При этом файл с курсами разбирается, и записываются
// только те данные, которые удовлетворяют периоду (НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки).
//
Функция ЗагрузитьКурсВалютыИзФайла(Знач Валюта, Знач ПутьКФайлу, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки)
	
	СтатусЗагрузки = 1;
	
	ЧислоЗагружаемыхДнейВсего = 1 + (ОкончаниеПериодаЗагрузки - НачалоПериодаЗагрузки) / ( 24 * 60 * 60);
	
	ЧислоЗагруженныхДней = 0;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла();
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПутьКФайлу);
		ДвоичныеДанные.Записать(ИмяФайла);
	Иначе
		ИмяФайла = ПутьКФайлу;
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент();
	
	
	Текст.Прочитать(ИмяФайла, КодировкаТекста.ANSI);
	
	ДатаЗапрета = Неопределено;
	Для НомерСтроки = 1 По Текст.КоличествоСтрок() Цикл
		
		Стр = Текст.ПолучитьСтроку(НомерСтроки);
		Если (Стр = "") ИЛИ (СтрНайти(Стр, Символы.Таб) = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		ЧастиСтроки = СтрРазделить(Стр, Символы.Таб, Истина);
		
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ДатаКурса = ОкончаниеПериодаЗагрузки;
			Кратность = Число(ЧастиСтроки[0]);
			Курс = Число(ЧастиСтроки[1]);
		Иначе
			ДатаКурсаСтр = ЧастиСтроки[0];
			ДатаКурса = Дата(Лев(ДатаКурсаСтр,4), Сред(ДатаКурсаСтр,5,2), Сред(ДатаКурсаСтр,7,2));
			Кратность = Число(ЧастиСтроки[1]);
			Курс = Число(ЧастиСтроки[2]);
		КонецЕсли;
		
		Если ДатаКурса > ОкончаниеПериодаЗагрузки Тогда
			Прервать;
		КонецЕсли;
		
		Если ДатаКурса < НачалоПериодаЗагрузки Тогда 
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Валюта.Установить(Валюта);
		НаборЗаписей.Отбор.Период.Установить(ДатаКурса);
		Запись = НаборЗаписей.Добавить();
		Запись.Валюта = Валюта;
		Запись.Период = ДатаКурса;
		Запись.Курс = Курс;
		Запись.Кратность = Кратность;
		
		Записывать = Истина;
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
			МодульДатыЗапретаИзмененияСлужебный = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзмененияСлужебный");
			Если МодульДатыЗапретаИзмененияСлужебный.ЗапретИзмененияПроверяется(Метаданные.РегистрыСведений.КурсыВалют) Тогда
				МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
				Записывать = Не МодульДатыЗапретаИзменения.ИзменениеЗапрещено(НаборЗаписей);
				Если Не Записывать Тогда
					Если ДатаЗапрета = Неопределено Тогда
						ДатаЗапрета = ДатаКурса;
					Иначе
						ДатаЗапрета = Макс(ДатаЗапрета, ДатаКурса);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Записывать Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЧислоЗагруженныхДней = ЧислоЗагруженныхДней + 1;
	КонецЦикла;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		УдалитьФайлы(ИмяФайла);
		УдалитьИзВременногоХранилища(ПутьКФайлу);
	КонецЕсли;
	
	ПояснениеОЗагрузке = "";
	Если ЧислоЗагружаемыхДнейВсего <> ЧислоЗагруженныхДней Тогда
		Если ЧислоЗагруженныхДней = 0 Тогда
			ПояснениеОЗагрузке = НСтр("ru = 'Курсы валюты %1 (%2) не загружены.
				|Нет сведение о курсе за указанный период.'");
		Иначе
			ПояснениеОЗагрузке = НСтр("ru = 'Загружены не все курсы по валюте %1 (%2).'");
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ПояснениеОЗагрузке) Тогда
		ПояснениеОЗагрузке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПояснениеОЗагрузке, Валюта.Наименование, Валюта.Код);
	КонецЕсли;
	
	Если ДатаЗапрета <> Неопределено Тогда
		ПояснениеОЗагрузке = ПояснениеОЗагрузке + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Загрузка курсов валюты %1(%2) ограничена датой запрета изменений %3.
			|Курсы запрещенного периода были пропущены при загрузке.'"), Валюта.Наименование, Валюта.Код, Формат(ДатаЗапрета, "ДЛФ=D"));
	КонецЕсли;
	
	ПояснениеОЗагрузке = СокрЛП(ПояснениеОЗагрузке);
	
	СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
	СписокОшибок = Новый Массив;
	Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
		СписокОшибок.Добавить(СообщениеПользователю.Текст);
	КонецЦикла;
	СписокОшибок = ОбщегоНазначенияКлиентСервер.СвернутьМассив(СписокОшибок);
	ПояснениеОЗагрузке = ПояснениеОЗагрузке + ?(ПустаяСтрока(ПояснениеОЗагрузке), "", Символы.ПС) + СтрСоединить(СписокОшибок, Символы.ПС);
	
	Возврат ПояснениеОЗагрузке;
	
КонецФункции

Процедура ОбновитьФорматХраненияПрописи() Экспорт
	
	ВыборкаВалют = Справочники.Валюты.Выбрать();
	
	Пока ВыборкаВалют.Следующий() Цикл
		Объект = ВыборкаВалют.ПолучитьОбъект();
		СтрокаПараметров = СтрЗаменить(Объект.ПараметрыПрописи, ",", Символы.ПС);
		Род1 = НРег(Лев(СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 4)), 1));
		Род2 = НРег(Лев(СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 8)), 1));
		Объект.ПараметрыПрописи = 
					  СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 1)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 2)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 3)) + ", "
					+ Род1 + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 5)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 6)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 7)) + ", "
					+ Род2 + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 9));
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЦикла;
	
КонецПроцедуры

// Отключает у валюты 643 загрузку из интернета.
Процедура ОтключитьЗагрузкуКурсаВалюты643ИзИнтернета(Параметры) Экспорт
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.Валюты");
	Пока Выборка.Следующий() Цикл
		Валюта = Выборка.Ссылка.ПолучитьОбъект();
		Валюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Валюта);
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Валюты");
КонецПроцедуры

Процедура УстановитьРасписаниеРегламентногоЗадания() Экспорт
	
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
	Задержка = ГенераторСлучайныхЧисел.СлучайноеЧисло(0, 21600); // С 0 до 6 часов утра.
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодНедель = 1;
	Расписание.ВремяНачала = '00010101000000' + Задержка;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 600);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 10);
	
	УстановитьПараметрыРегламентногоЗадания(ПараметрыЗадания);
	
КонецПроцедуры

Процедура УстановитьПараметрыРегламентногоЗадания(ИзменяемыеПараметры)
	РегламентныеЗаданияСервер.УстановитьПараметрыРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют, ИзменяемыеПараметры);
КонецПроцедуры

Функция ПараметрыАутентификацииНаСайте()
	Результат = Новый Структура;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если ДанныеАутентификации <> Неопределено Тогда
			Результат.Вставить("Пользователь", ДанныеАутентификации.Логин);
			Результат.Вставить("Пароль", ДанныеАутентификации.Пароль);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ВалютыЗагружаемыеИзИнтернета()
	КлассификаторXML = ПолучитьМакет("ОбщероссийскийКлассификаторВалют").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	НайденныеСтроки = КлассификаторТаблица.НайтиСтроки(Новый Структура("RBCLoading", "истина"));
	ЗагружаемыеПоКлассификатору = КлассификаторТаблица.Скопировать(НайденныеСтроки, "Code").ВыгрузитьКолонку("Code");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	НЕ Валюты.ПометкаУдаления
	|	И Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
	|	И Валюты.Код В(&ЗагружаемыеПоКлассификатору)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЗагружаемыеПоКлассификатору", ЗагружаемыеПоКлассификатору);
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
КонецФункции

Функция ИмяСобытияЖурналаРегистрации()
	Возврат НСтр("ru = 'Валюты.Загрузка курсов валют'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецФункции

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки.
Процедура ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки(ДанныеПользователя) Экспорт
	УстановитьПараметрыРегламентногоЗадания(Новый Структура("Использование", Истина));
КонецПроцедуры

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки.
Процедура ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки() Экспорт
	УстановитьПараметрыРегламентногоЗадания(Новый Структура("Использование", Ложь));
КонецПроцедуры

#КонецОбласти

#КонецЕсли