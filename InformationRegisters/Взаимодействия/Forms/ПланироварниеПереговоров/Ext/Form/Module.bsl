﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ответственный = ПользователиКлиентСервер.АвторизованныйПользователь();
	
	ЭтоМенеджерГПТ = УправлениеДоступом.ЕстьРоль("МенеджерГПТ", , Ответственный); 
	ЭтоМенеджерФилиала = УправлениеДоступом.ЕстьРоль("МенеджерФилиала", , Ответственный);
	
	Если Параметры.Свойство("ДанныеУчастника") Тогда
		АдресДанныхУчастника = ПоместитьВоВременноеХранилище(Параметры.ДанныеУчастника, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗвонок(Команда)
		
	ОписаниеОповещенияОЗакрытииДопФормВзаимодействий = Новый ОписаниеОповещения("ЗавершениеЗакрытияДопФормВзаимодействий", ЭтотОбъект);
	ПараметрыОткрытияФормы = ПодготовитьПараметрыОткрытияФормы(Параметры.Предмет, Параметры.Проект, ?(ЭтоАдресВременногоХранилища(АдресДанныхУчастника), ПолучитьИзВременногоХранилища(АдресДанныхУчастника), Неопределено), "Документ.ТелефонныйЗвонок.Форма.ФормаДокумента_Нов", ЭтоМенеджерГПТ, ЭтоМенеджерФилиала);	
	
	Если ПараметрыОткрытияФормы.ВзаимодействияДляОткрытия.Количество() Тогда
		Для каждого Взаимодействие Из ПараметрыОткрытияФормы.ВзаимодействияДляОткрытия Цикл	
			//ПоказатьЗначение(ОписаниеОповещенияОЗакрытииДопФормВзаимодействий, Взаимодействие);
			ФормаВзаимодействия = ?(ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.Встреча"), "Документ.Встреча.ФормаОбъекта", "Документ.ТелефонныйЗвонок.ФормаОбъекта"); 
			ПараметрыФормы = Новый Структура("Ключ", Взаимодействие);
			ОткрытьФорму(ФормаВзаимодействия, , ЭтаФорма, Истина, , , ОписаниеОповещенияОЗакрытииДопФормВзаимодействий, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);			
		КонецЦикла;
	Иначе
		Если ЗначениеЗаполнено(ПараметрыОткрытияФормы.ФормаВзаимодействия) Тогда
			ОткрытьФорму(ПараметрыОткрытияФормы.ФормаВзаимодействия, ПараметрыОткрытияФормы.ПараметрыНовогоВзаимодействия, ЭтаФорма, Истина, , , ОписаниеОповещенияОЗакрытииДопФормВзаимодействий, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВстречу(Команда)
	
	ОписаниеОповещенияОЗакрытииДопФормВзаимодействий = Новый ОписаниеОповещения("ЗавершениеЗакрытияДопФормВзаимодействий", ЭтотОбъект);	
	ПараметрыОткрытияФормы = ПодготовитьПараметрыОткрытияФормы(Параметры.Предмет, Параметры.Проект, ?(ЭтоАдресВременногоХранилища(АдресДанныхУчастника), ПолучитьИзВременногоХранилища(АдресДанныхУчастника), Неопределено), "Документ.Встреча.ФормаОбъекта", ЭтоМенеджерГПТ, ЭтоМенеджерФилиала);	
	
	Если ПараметрыОткрытияФормы.ВзаимодействияДляОткрытия.Количество() Тогда
		Для каждого Взаимодействие Из ПараметрыОткрытияФормы.ВзаимодействияДляОткрытия Цикл	
			//ПоказатьЗначение(ОписаниеОповещенияОЗакрытииДопФормВзаимодействий, Взаимодействие);	
			ФормаВзаимодействия = ?(ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.Встреча"), "Документ.Встреча.ФормаОбъекта", "Документ.ТелефонныйЗвонок.ФормаОбъекта"); 
			ПараметрыФормы = Новый Структура("Ключ", Взаимодействие);
			ОткрытьФорму(ФормаВзаимодействия, , ЭтаФорма, Истина, , , ОписаниеОповещенияОЗакрытииДопФормВзаимодействий, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);			
		КонецЦикла;
	Иначе
		Если ЗначениеЗаполнено(ПараметрыОткрытияФормы.ФормаВзаимодействия) Тогда
			ОткрытьФорму(ПараметрыОткрытияФормы.ФормаВзаимодействия, ПараметрыОткрытияФормы.ПараметрыНовогоВзаимодействия, ЭтаФорма, Истина, , , ОписаниеОповещенияОЗакрытииДопФормВзаимодействий, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Скрыть(Команда)
	Закрыть();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьПараметрыОткрытияФормы(Предмет, Проект, ДанныеУчастника, ФормаВзаимодействия, МенеджерГПТ, МенеджерФилиала)
	
	ВзаимодействияДляОткрытия = Новый Массив;
	ПараметрыНовогоВзаимодействия = Неопределено;	
		
	Если МенеджерГПТ Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоставыГруппПользователей.Пользователь КАК Пользователь
		|ПОМЕСТИТЬ ВТ_ПользователиГПТ
		|ИЗ
		|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|ГДЕ
		|	СоставыГруппПользователей.ГруппаПользователей.Наименование = ""ГПТ""
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Взаимодействия.Взаимодействие КАК Взаимодействие
		|ИЗ
		|	РегистрСведений.Взаимодействия КАК Взаимодействия
		|ГДЕ
		|	Взаимодействия.Предмет = &Предмет
		|	И Взаимодействия.ТипВзаимодействия = &ТипВзаимодействия
		|	И Взаимодействия.Статус = &Статус
		|	И ВЫБОР
		|			КОГДА НЕ Взаимодействия.Взаимодействие ССЫЛКА Справочник.Сделки
		|				ТОГДА Взаимодействия.Взаимодействие.Автор В
		|						(ВЫБРАТЬ
		|							ВТ_ПользователиГПТ.Пользователь КАК Пользователь
		|						ИЗ
		|							ВТ_ПользователиГПТ КАК ВТ_ПользователиГПТ)
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ";

		Запрос.УстановитьПараметр("Предмет", Предмет);
		Запрос.УстановитьПараметр("ТипВзаимодействия", ?(СтрНайти(ФормаВзаимодействия, "ТелефонныйЗвонок"), Перечисления.ТипыВзаимодействий.ТелефонныйЗвонок, Перечисления.ТипыВзаимодействий.Встреча));
		Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыВзаимодействий.Запланировано);
		Запрос.УстановитьПараметр("ГруппаОтветственного", Справочники.ГруппыПользователей.НайтиПоНаименованию("ГПТ"));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ВзаимодействияДляОткрытия.Добавить(ВыборкаДетальныеЗаписи.Взаимодействие);
		КонецЦикла;
		
		Если НЕ ВзаимодействияДляОткрытия.Количество() Тогда		
			Если СтрНайти(ФормаВзаимодействия, "Встреча") Тогда					
				Офис = "";
				ВидНедвижимости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Проект, "ВидНедвижимости");
				Если ВидНедвижимости = Перечисления.ВидыОбъектовНедвижимости.ЖилаяНедвижимость Тогда
					Офис = "Филиал";	
				ИначеЕсли ВидНедвижимости = Перечисления.ВидыОбъектовНедвижимости.ЗемельныйУчасток Тогда
					Офис = "Экскурсия";	
				КонецЕсли;
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	СоответствиеГруппПользователейОфисам.ГруппаПользователей КАК Ответственный
				|ИЗ
				|	РегистрСведений.СоответствиеГруппПользователейОфисам КАК СоответствиеГруппПользователейОфисам
				|ГДЕ
				|	СоответствиеГруппПользователейОфисам.Офис = &Офис
				|	И СоответствиеГруппПользователейОфисам.Проект = &Проект
				|	И СоответствиеГруппПользователейОфисам.ГруппаПользователей В ИЕРАРХИИ(&ГруппаРодитель)
				|	И НЕ СоответствиеГруппПользователейОфисам.ГруппаПользователей.ПометкаУдаления
				|
				|УПОРЯДОЧИТЬ ПО
				|	СоответствиеГруппПользователейОфисам.ГруппаПользователей.Наименование";
				
				Запрос.УстановитьПараметр("Офис", Офис);
				Запрос.УстановитьПараметр("Проект", Проект);
				Запрос.УстановитьПараметр("ГруппаРодитель", ?(Офис = "Экскурсия", Справочники.ГруппыПользователей.НайтиПоНаименованию("Земля розница", Истина), Справочники.ГруппыПользователей.НайтиПоНаименованию("Филиал", Истина)));
				
				РезультатЗапроса = Запрос.Выполнить();			
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();			
				Если ВыборкаДетальныеЗаписи.Следующий() Тогда
					Ответственный = ВыборкаДетальныеЗаписи.Ответственный;
				КонецЕсли;	
				
				ПараметрыНовогоВзаимодействия = Новый Структура("Предмет, Ответственный, Офис, ДанныеУчастника", Предмет, Ответственный, Офис, ДанныеУчастника);
			ИначеЕсли СтрНайти(ФормаВзаимодействия, "ТелефонныйЗвонок") Тогда
				ПараметрыНовогоВзаимодействия = Новый Структура("Предмет, Ответственный, ДанныеУчастника", Предмет, Пользователи.ТекущийПользователь(), ДанныеУчастника);	
			КонецЕсли;
		КонецЕсли;
	Иначе		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Взаимодействия.Взаимодействие КАК Взаимодействие
		|ИЗ
		|	РегистрСведений.Взаимодействия КАК Взаимодействия
		|ГДЕ
		|	Взаимодействия.Предмет = &Предмет
		|	И Взаимодействия.ТипВзаимодействия = &ТипВзаимодействия
		|	И Взаимодействия.Статус = &Статус
		|	И ВЫБОР
		|			КОГДА НЕ Взаимодействия.Взаимодействие ССЫЛКА Справочник.Сделки
		|				ТОГДА Взаимодействия.Взаимодействие.Автор В ИЕРАРХИИ (&ГруппаОтветственного)
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ";
		
		Запрос.УстановитьПараметр("Предмет", Предмет);
		Запрос.УстановитьПараметр("ТипВзаимодействия", ?(СтрНайти(ФормаВзаимодействия, "ТелефонныйЗвонок"), Перечисления.ТипыВзаимодействий.ТелефонныйЗвонок, Перечисления.ТипыВзаимодействий.Встреча));
		Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыВзаимодействий.Запланировано);
		Запрос.УстановитьПараметр("ГруппаОтветственного", РегистрыСведений.Взаимодействия.ПолучитьГруппуОтветственного(Пользователи.ТекущийПользователь(), ТекущаяДата()));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ВзаимодействияДляОткрытия.Добавить(ВыборкаДетальныеЗаписи.Взаимодействие);
		КонецЦикла;
		
		Если НЕ ВзаимодействияДляОткрытия.Количество() Тогда		
			Если СтрНайти(ФормаВзаимодействия, "Встреча") Тогда					
				Офис = "";
				ВидНедвижимости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Проект, "ВидНедвижимости");
				Если ВидНедвижимости = Перечисления.ВидыОбъектовНедвижимости.ЖилаяНедвижимость Тогда
					Офис = "Филиал";	
				ИначеЕсли ВидНедвижимости = Перечисления.ВидыОбъектовНедвижимости.ЗемельныйУчасток Тогда
					Офис = "Экскурсия";	
				КонецЕсли;
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	СоответствиеГруппПользователейОфисам.ГруппаПользователей КАК Ответственный
				|ИЗ
				|	РегистрСведений.СоответствиеГруппПользователейОфисам КАК СоответствиеГруппПользователейОфисам
				|ГДЕ
				|	СоответствиеГруппПользователейОфисам.Офис = &Офис
				|	И СоответствиеГруппПользователейОфисам.Проект = &Проект
				|	И СоответствиеГруппПользователейОфисам.ГруппаПользователей В ИЕРАРХИИ(&ГруппаРодитель)
				|	И НЕ СоответствиеГруппПользователейОфисам.ГруппаПользователей.ПометкаУдаления
				|
				|УПОРЯДОЧИТЬ ПО
				|	СоответствиеГруппПользователейОфисам.ГруппаПользователей.Наименование";
				
				Запрос.УстановитьПараметр("Офис", Офис);
				Запрос.УстановитьПараметр("Проект", Проект);					
				Запрос.УстановитьПараметр("ГруппаРодитель", ?(Офис = "Экскурсия", Справочники.ГруппыПользователей.НайтиПоНаименованию("Земля розница", Истина), Справочники.ГруппыПользователей.НайтиПоНаименованию("Филиал", Истина)));
				
				РезультатЗапроса = Запрос.Выполнить();			
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();			
				Если ВыборкаДетальныеЗаписи.Следующий() Тогда
					ГруппаОтветственного = ВыборкаДетальныеЗаписи.Ответственный;
				КонецЕсли;				
								
				ПараметрыНовогоВзаимодействия = Новый Структура("Предмет, Ответственный, ГруппаОтветственного, Офис, ДанныеУчастника", Предмет, Пользователи.ТекущийПользователь(), ГруппаОтветственного, Офис, ДанныеУчастника);
			ИначеЕсли СтрНайти(ФормаВзаимодействия, "ТелефонныйЗвонок") Тогда
				ПараметрыНовогоВзаимодействия = Новый Структура("Предмет, Ответственный, ДанныеУчастника", Предмет, Пользователи.ТекущийПользователь(), ДанныеУчастника);	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
			
	Возврат Новый Структура("ФормаВзаимодействия, ПараметрыНовогоВзаимодействия, ВзаимодействияДляОткрытия", ФормаВзаимодействия, ПараметрыНовогоВзаимодействия, ВзаимодействияДляОткрытия);
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеЗакрытияДопФормВзаимодействий(Результат, ДополнительныеПараметры) Экспорт	
	
	Если ЭтаФорма.Открыта() Тогда
		Закрыть();			
	КонецЕсли;
	
КонецПроцедуры
