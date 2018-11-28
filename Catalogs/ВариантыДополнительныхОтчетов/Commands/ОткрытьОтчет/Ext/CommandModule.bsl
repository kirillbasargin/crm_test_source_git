﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВыполняемаяКоманда = ДанныеКомандыВнешнегоОтчета(ПараметрКоманды);
	
	Если ВыполняемаяКоманда.Контекстный Тогда
		Состояние(НСтр("ru = 'Отчет можно открыть только из объектов БД'"));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыполняемаяКоманда.Автор) И ВыполняемаяКоманда.ТолькоДляАвтора И НЕ ВыполняемаяКоманда.ЭтоПолноправныйПользователь И НЕ ВыполняемаяКоманда.ТекущийПользователь=ВыполняемаяКоманда.Автор Тогда
		Состояние(НСтр("ru = 'Нарушение прав доступа'"));
		Возврат;
	КонецЕсли; 
	
	Если ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, ПараметрыВыполненияКоманды.Источник, ВыполняемаяКоманда.ОбъектыНазначения);
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, ПараметрыВыполненияКоманды.Источник, ВыполняемаяКоманда.ОбъектыНазначения);
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
		Или ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
		
		ПараметрыВызоваСервера = Новый Структура("ДополнительнаяОбработкаСсылка, ИдентификаторКоманды, ОбъектыНазначения");
		ПараметрыВызоваСервера.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
		ПараметрыВызоваСервера.ИдентификаторКоманды   = ВыполняемаяКоманда.Идентификатор;
		ПараметрыВызоваСервера.ОбъектыНазначения      = ВыполняемаяКоманда.ОбъектыНазначения;
		
		Задание = ОбработкаКомандыСервер(ПараметрыВызоваСервера);
	
		Если Задание.Завершено Тогда
			ПоказатьРезультатВыполненияОбработки(Задание, ВыполняемаяКоманда, ПараметрыВыполненияКоманды.Источник);
		Иначе
			Состояние(НСтр("ru = 'Выполняется команда...'"),,, БиблиотекаКартинок.ДлительнаяОперация48);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаКомандыСервер(ПараметрыВызоваСервера)
	
	Возврат ДополнительныеОтчетыИОбработки.ВыполнитьКоманду(ПараметрыВызоваСервера);	
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДанныеКомандыВнешнегоОтчета(Вариант)
	
	ВыполняемаяКоманда = Новый Структура(
		"Ссылка, Представление, Автор, ТолькоДляАвтора, 
		|Идентификатор, ВариантЗапуска, ПоказыватьОповещение, 
		|Модификатор, ОбъектыНазначения, ЭтоОтчет, Вид, Контекстный");
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Вариант", Вариант);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительныеОтчетыИОбработкиКоманды.Ссылка,
	|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор,
	|	ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска,
	|	ДополнительныеОтчетыИОбработкиКоманды.Представление,
	|	ДополнительныеОтчетыИОбработкиКоманды.ПоказыватьОповещение,
	|	ДополнительныеОтчетыИОбработкиКоманды.Модификатор,
	|	ДополнительныеОтчетыИОбработкиКоманды.Ссылка.Вид КАК Вид,
	|	ВариантыДополнительныхОтчетов.Контекстный,
	|	ВариантыДополнительныхОтчетов.Автор,
	|	ВариантыДополнительныхОтчетов.ТолькоДляАвтора
	|ИЗ
	|	Справочник.ВариантыДополнительныхОтчетов КАК ВариантыДополнительныхОтчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
	|		ПО ВариантыДополнительныхОтчетов.Отчет = ДополнительныеОтчетыИОбработкиКоманды.Ссылка
	|			И ВариантыДополнительныхОтчетов.ИдентификаторКоманды = ДополнительныеОтчетыИОбработкиКоманды.Идентификатор
	|ГДЕ
	|	ВариантыДополнительныхОтчетов.Ссылка = &Вариант";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Ссылка) Тогда
		ЗаполнитьЗначенияСвойств(ВыполняемаяКоманда, Выборка);
		ВыполняемаяКоманда.ЭтоОтчет = Истина;
	КонецЕсли;
	ВыполняемаяКоманда.Вставить("ТекущийПользователь", Пользователи.ТекущийПользователь());	
	ВыполняемаяКоманда.Вставить("ЭтоПолноправныйПользователь", Пользователи.ЭтоПолноправныйПользователь(ВыполняемаяКоманда.ТекущийПользователь));	
	Возврат ВыполняемаяКоманда;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьРезультатВыполненияОбработки(Задание, ВыполняемаяКоманда, ВладелецФормы)
	
	// Добавление оповещения в результат выполнения (если требуется).
	РезультатВыполнения = Задание.Значение;
	Если РезультатВыполнения = Неопределено Тогда
		РезультатВыполнения = Новый Структура;
	КонецЕсли;
	
	Если Задание.Успешно Тогда
		// Показать всплывающее оповещение.
		Если ВыполняемаяКоманда.ПоказыватьОповещение Тогда
			СтандартныеПодсистемыКлиентСервер.ВывестиОповещение(
				РезультатВыполнения,
				НСтр("ru = 'Команда выполнена'"),
				ВыполняемаяКоманда.Представление);
		КонецЕсли;
		
		// Обновить форму владельца
		Попытка
			ВладелецФормы.Прочитать();
		Исключение
			// Действие не требуется.
		КонецПопытки;
	КонецЕсли;
	
	// Вывод результата выполнения.
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ВладелецФормы, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти 



