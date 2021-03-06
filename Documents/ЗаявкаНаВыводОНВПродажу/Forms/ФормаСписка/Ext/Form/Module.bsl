﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборДляСтаршегоМенеджера = Неопределено;
	
	Если Параметры.Свойство("ОтборДляСтаршегоМенеджера", ОтборДляСтаршегоМенеджера) Тогда
	
		Если ОтборДляСтаршегоМенеджера Тогда
			
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Статус");
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Перечисления.СтатусЗаявкиНаВыводОНВПродажу.СогласованиеЗаявки, ВидСравненияКомпоновкиДанных.Равно, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проект", ПолучитьСписокПроектов(ПользователиКлиентСервер.ТекущийПользователь()), ВидСравненияКомпоновкиДанных.ВСписке, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);

		Иначе
			
			//ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Перечисления.СтатусЗаявкиНаВыводОНВПродажу.ВыполненаВОКМЦ, ВидСравненияКомпоновкиДанных.НеРавно, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			
		КонецЕсли;	
	
	КонецЕсли;
	
	Если Параметры.Свойство("Автор") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Автор", Параметры.Автор, ВидСравненияКомпоновкиДанных.Равно, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Для каждого ЭлементНастройки Из Настройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастройки) = Тип("ОтборКомпоновкиДанных") Тогда
			Для каждого ЭлементОтбора Из ЭлементНастройки.Элементы Цикл
				ЭлементОтбора.Использование = Ложь;
				ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборКвартир(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ПараметрыФормыОтчета = Новый Структура("Отбор");
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		Проект = ТекущиеДанные.Проект;
		ПроектВидНедвижимости = ТекущиеДанные.ПроектВидНедвижимости;
		
		ПараметрыФормыОтчета.Вставить("СформироватьПриОткрытии", Истина);	
		ПараметрыФормыОтчета.Вставить("СвернутьПанельНастроек", Истина);
		
		СтруктураОтбора = Новый Структура();	
		
		Если ЗначениеЗаполнено(Проект) Тогда	
			СтруктураОтбора.Вставить("Проект", Проект);		
		КонецЕсли;
		
		ДополнитьПараметрыОтчетаНаСервере(ПараметрыФормыОтчета, СтруктураОтбора, Проект, ПроектВидНедвижимости);
		
		ПараметрыФормыОтчета.Отбор = СтруктураОтбора;
	Иначе
		ПараметрыФормыОтчета.Вставить("СформироватьПриОткрытии", Ложь);		
	КонецЕсли;
	
	ФормаКвартирограммы = ОткрытьФорму("Отчет.Квартирограмма.Форма.ФормаПодбора", ПараметрыФормыОтчета, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор, , , );
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетШахматка(Команда)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;	
	Если ТекДанные <> Неопределено Тогда		
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);		
		ПараметрыФормы.Вставить("Отбор", Новый Структура("ОбъектСтроительства", ТекДанные.ОС));
		ПараметрыФормы.Вставить("ОбъектНедвижимостиВыделение",	ТекДанные.ОбъектНедвижимости);		
		ДополнитьПараметрыОтчета(ТекДанные.ОбъектНедвижимости, ТекДанные.ОС, ПараметрыФормы); 
	Иначе
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Ложь);
	КонецЕсли;
		
	//ОткрытьФорму("Отчет.Шахматка.Форма.ФормаОтчета", ПараметрыФормы, ЭтаФорма, Новый УникальныйИдентификатор());			
	ОткрытьФорму("Отчет.Шахматка.Форма.ФормаОтчета", ПараметрыФормы, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор, , , , );
	
КонецПроцедуры

&НаКлиенте
Процедура Согласовать(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.СтатусЗаявкиНаВыводОНВПродажу.СогласованиеЗаявки") Тогда
		СогласоватьНаСервере("СогласованаРуководителемФилиала", ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отклонить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.СтатусЗаявкиНаВыводОНВПродажу.СогласованиеЗаявки") Тогда	
		СогласоватьНаСервере("ОтклоненаРуководителемФилиала", ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокПроектов(Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
       |	ГруппыПользователейСостав.Ссылка КАК Ссылка
       |ПОМЕСТИТЬ ВТ_Группы
       |ИЗ
       |	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
       |ГДЕ
       |	ГруппыПользователейСостав.Пользователь = &Пользователь
       |;
       |
       |////////////////////////////////////////////////////////////////////////////////
       |ВЫБРАТЬ РАЗРЕШЕННЫЕ
       |	СоответствиеГруппПользователейОфисам.Проект КАК Проект
       |ИЗ
       |	РегистрСведений.СоответствиеГруппПользователейОфисам КАК СоответствиеГруппПользователейОфисам
       |ГДЕ
       |	СоответствиеГруппПользователейОфисам.ГруппаПользователей В
       |			(ВЫБРАТЬ
       |				ВТ_Группы.Ссылка КАК Ссылка
       |			ИЗ
       |				ВТ_Группы КАК ВТ_Группы)
       |
       |СГРУППИРОВАТЬ ПО
       |	СоответствиеГруппПользователейОфисам.Проект";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Список 	= Новый СписокЗначений();//Массив;		
		Пока Выборка.Следующий() Цикл
			Список.Добавить(Выборка.Проект);
		КонецЦикла;		
		Возврат Список;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ДополнитьПараметрыОтчетаНаСервере(ПараметрыФормыОтчета, СтруктураОтбора, Проект, ТипОбъектаНедвижимости)
			
	ВариантОтчета = ОпределитьВариантОтчета(ТипОбъектаНедвижимости);
	ПараметрыФормыОтчета.Вставить("ВариантГПТ", ВариантОтчета.ВариантГПТ);
	Если ЗначениеЗаполнено(ВариантОтчета.КлючТекущегоВарианта) Тогда
		ПараметрыФормыОтчета.Вставить("КлючТекущегоВарианта", ВариантОтчета.КлючТекущегоВарианта);	
		Если СтрНайти(ВариантОтчета.НаименованиеВарианта, "ЗУ") Тогда
			Если СтруктураОтбора.Свойство("Услуга") Тогда
				СтруктураОтбора.Удалить("Услуга");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипОбъектаНедвижимости) Тогда
		НазначенияОН = ОпределитьНазначенияОН(Проект, ТипОбъектаНедвижимости);
		Если НазначенияОН.Количество() Тогда
			СтруктураОтбора.Вставить("НазначениеОН", НазначенияОН);
		Иначе
			СтруктураОтбора.Вставить("ПроектВидНедвижимости", ТипОбъектаНедвижимости);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры	

Функция ОпределитьВариантОтчета(ТипОбъектаНедвижимости)
	
	КлючТекущегоВарианта = Неопределено;
	ВариантГПТ = Ложь;
	Если ТипОбъектаНедвижимости = Перечисления.ВидыОбъектовНедвижимости.ЖилаяНедвижимость Тогда
		КлючТекущегоВарианта = "ГПТ";
		ВариантГПТ = Истина;
	ИначеЕсли ТипОбъектаНедвижимости = Перечисления.ВидыОбъектовНедвижимости.ЗемельныйУчасток Тогда
		КлючТекущегоВарианта = "ЗУ";
	ИначеЕсли ТипОбъектаНедвижимости = Перечисления.ВидыОбъектовНедвижимости.Машиноместо Тогда
		КлючТекущегоВарианта = "Машиноместа";
	ИначеЕсли ТипОбъектаНедвижимости = Перечисления.ВидыОбъектовНедвижимости.НежилаяНедвижимость Тогда
		КлючТекущегоВарианта = "Кладовые";
	Иначе
		КлючТекущегоВарианта = "ГПТ";
		ВариантГПТ = Истина;
	КонецЕсли;
	
	//<840014>, Басаргин (04.07.2018) {
	ЭтоМенеджерФилиала = УправлениеДоступом.ЕстьРоль("МенеджерФилиала", , ПользователиКлиентСервер.АвторизованныйПользователь()) 
							И НЕ УправлениеДоступом.ЕстьРоль("ПолныеПрава", , ПользователиКлиентСервер.АвторизованныйПользователь());
							
	Если КлючТекущегоВарианта = "ГПТ" И ЭтоМенеджерФилиала Тогда
		КлючТекущегоВарианта = "ПодборОН_БТИ";
		ВариантГПТ = Истина;
	КонецЕсли;      
	//<840014> }
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВариантыОтчетов.Ссылка КАК ВариантСсылка,
	|	ВариантыОтчетов.Наименование КАК Наименование,
	|	ВариантыОтчетов.КлючВарианта КАК КлючВарианта	
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Отчет.Имя = ""Квартирограмма""
	|	И ВариантыОтчетов.Автор = &Автор
	|	И ВариантыОтчетов.Пользовательский
	|	И ВариантыОтчетов.Наименование ПОДОБНО &КлючВарианта
	|	И НЕ ВариантыОтчетов.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("КлючВарианта", КлючТекущегоВарианта + "%");
	Запрос.УстановитьПараметр("Автор", ПользователиКлиентСервер.АвторизованныйПользователь());

	НаименованиеВарианта = "";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		КлючТекущегоВарианта = Выборка.КлючВарианта;
		НаименованиеВарианта = Выборка.Наименование;
	КонецЕсли;
	
	Возврат Новый Структура("КлючТекущегоВарианта, ВариантГПТ, НаименованиеВарианта", КлючТекущегоВарианта, ВариантГПТ, НаименованиеВарианта);	
		
КонецФункции

&НаСервере
Функция ОпределитьНазначенияОН(Проект, ТипОН)
	
	НазначенияОН = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СоответствиеТипаИНазначенияОН.НазначениеОН КАК НазначениеОН
	|ИЗ
	|	РегистрСведений.СоответствиеТипаИНазначенияОН КАК СоответствиеТипаИНазначенияОН
	|ГДЕ
	|	СоответствиеТипаИНазначенияОН.Проект = &Проект
	|	И СоответствиеТипаИНазначенияОН.ТипОН = &ТипОН";
	
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("ТипОН", ТипОН);
	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НазначенияОН.Добавить(ВыборкаДетальныеЗаписи.НазначениеОН);
	КонецЦикла;
	
	Возврат НазначенияОН;
	
КонецФункции

&НаСервере
Процедура ДополнитьПараметрыОтчета(Квартира, Корпус, ПараметрыФормы)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Квартирограмма.Этаж КАК Этаж,
	|	Квартирограмма.Подъезд КАК Подъезд,
	|	Квартирограмма.ОбъектСтроительства.МаксимальнаяЭтажность КАК ОбъектСтроительстваМаксимальнаяЭтажность
	|ИЗ
	|	РегистрСведений.Квартирограмма КАК Квартирограмма
	|ГДЕ
	|	Квартирограмма.ОбъектНедвижимости = &ОбъектНедвижимости
	|	И Квартирограмма.ОбъектСтроительства = &ОбъектСтроительства";
	
	Запрос.УстановитьПараметр("ОбъектНедвижимости", Квартира);
	Запрос.УстановитьПараметр("ОбъектСтроительства", Корпус);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ПараметрыФормы.Вставить("Подъезд",	ВыборкаДетальныеЗаписи.Подъезд);
		ПараметрыФормы.Вставить("ЭтажПерехода",	ВыборкаДетальныеЗаписи.Этаж);
		ПараметрыФормы.Вставить("ВсегоЭтажей",	ВыборкаДетальныеЗаписи.ОбъектСтроительстваМаксимальнаяЭтажность);
	КонецЕсли;
				
КонецПроцедуры

&НаСервере
Процедура СогласоватьНаСервере(Знач Статус, Ссылка)
	
	ЗаявкаОбъект = Ссылка.ПолучитьОбъект();
	Если НЕ ЗаявкаОбъект = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаявкаОбъект.Статус = Перечисления.СтатусЗаявкиНаВыводОНВПродажу[Статус];
	ЗаявкаОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти