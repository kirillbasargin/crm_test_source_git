﻿#Область ПрограммныйИнтерфейс

// Идентификатор, который используется для начальной страницы в модуле ВариантыОтчетовПереопределяемый.
//
// Возвращаемое значение:
//   Строка - Идентификатор, который используется для начальной страницы в модуле ВариантыОтчетовПереопределяемый.
//
Функция ИдентификаторНачальнойСтраницы() Экспорт
	
	Возврат "Подсистемы";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет Ключ в Структуру если его нет.
//
// Параметры:
//   Структура - Структура    - Дополняемая структура.
//   Ключ      - Строка       - Имя свойства.
//   Значение  - Произвольный - Необязательный. Значение свойства если оно отсутствует в структуре.
//
Процедура ДополнитьСтруктуруКлючом(Структура, Ключ, Значение = Неопределено) Экспорт
	Если Не Структура.Свойство(Ключ) Тогда
		Структура.Вставить(Ключ, Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Представление подсистемы. Используется при записи в журнал регистрации и в других местах.
Функция НаименованиеПодсистемы(КодЯзыка) Экспорт
	Возврат НСтр("ru = 'Варианты отчетов'", ?(КодЯзыка = Неопределено, ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(), КодЯзыка));
КонецФункции

// Представление группы важности.
Функция ПредставлениеСмТакже() Экспорт
	Возврат НСтр("ru = 'См. также'");
КонецФункции 

// Представление группы важности.
Функция ПредставлениеВажный() Экспорт
	Возврат НСтр("ru = 'Важный'");
КонецФункции

// Имя события оповещения для изменения варианта отчета.
Функция ИмяСобытияИзменениеВарианта() Экспорт
	Возврат ПолноеИмяПодсистемы() + ".ИзменениеВарианта";
КонецФункции

// Имя события оповещения для изменения общих настроек.
Функция ИмяСобытияИзменениеОбщихНастроек() Экспорт
	Возврат ПолноеИмяПодсистемы() + ".ИзменениеОбщихНастроек";
КонецФункции

// Краткое имя подсистемы.
Функция ИмяПодсистемы()
	Возврат "ВариантыОтчетов";
КонецФункции

// Полное имя подсистемы.
Функция ПолноеИмяПодсистемы() Экспорт
	Возврат "СтандартныеПодсистемы." + ИмяПодсистемы();
КонецФункции

// Разделитель, который используется при хранении нескольких наименований в одном строковом реквизите.
Функция РазделительХранения() Экспорт
	Возврат Символы.ПС;
КонецФункции

// Разделитель, который используется для отображения нескольких наименований в интерфейсе.
Функция РазделительПредставления() Экспорт
	Возврат ", ";
КонецФункции

// Превращает строку поиска в массив слов с уникальными значениями, отсортированный по убыванию длины.
Функция РазложитьСтрокуПоискаВМассивСлов(СтрокаПоиска) Экспорт
	СловаИИхДлина = Новый СписокЗначений;
	ДлинаСтроки = СтрДлина(СтрокаПоиска);
	
	Слово = "";
	ДлинаСлова = 0;
	ОткрытаКавычка = Ложь;
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		КодСимвола = КодСимвола(СтрокаПоиска, НомерСимвола);
		Если КодСимвола = 34 Тогда // 34 - двойная кавычка ".
			ОткрытаКавычка = Не ОткрытаКавычка;
		ИначеЕсли ОткрытаКавычка
			Или (КодСимвола >= 48 И КодСимвола <= 57) // цифры
			Или (КодСимвола >= 65 И КодСимвола <= 90) // латиница большие
			Или (КодСимвола >= 97 И КодСимвола <= 122) // латиница маленькие
			Или (КодСимвола >= 1040 И КодСимвола <= 1103) // кириллица
			Или КодСимвола = 95 Тогда // символ "_"
			Слово = Слово + Символ(КодСимвола);
			ДлинаСлова = ДлинаСлова + 1;
		ИначеЕсли Слово <> "" Тогда
			Если СловаИИхДлина.НайтиПоЗначению(Слово) = Неопределено Тогда
				СловаИИхДлина.Добавить(Слово, Формат(ДлинаСлова, "ЧЦ=3; ЧВН="));
			КонецЕсли;
			Слово = "";
			ДлинаСлова = 0;
		КонецЕсли;
	КонецЦикла;
	
	Если Слово <> "" И СловаИИхДлина.НайтиПоЗначению(Слово) = Неопределено Тогда
		СловаИИхДлина.Добавить(Слово, Формат(ДлинаСлова, "ЧЦ=3; ЧВН="));
	КонецЕсли;
	
	СловаИИхДлина.СортироватьПоПредставлению(НаправлениеСортировки.Убыв);
	
	Возврат СловаИИхДлина.ВыгрузитьЗначения();
КонецФункции

// Превращает тип отчета в строковый идентификатор.
Функция ТипОтчетаСтрокой(Знач ТипОтчета, Знач Отчет = Неопределено) Экспорт
	ТипТипаОтчета = ТипЗнч(ТипОтчета);
	Если ТипТипаОтчета = Тип("Строка") Тогда
		Возврат ТипОтчета;
	ИначеЕсли ТипТипаОтчета = Тип("ПеречислениеСсылка.ТипыОтчетов") Тогда
		Если ТипОтчета = ПредопределенноеЗначение("Перечисление.ТипыОтчетов.Внутренний") Тогда
			Возврат "Внутренний";
		ИначеЕсли ТипОтчета = ПредопределенноеЗначение("Перечисление.ТипыОтчетов.Расширение") Тогда
			Возврат "Расширение";
		ИначеЕсли ТипОтчета = ПредопределенноеЗначение("Перечисление.ТипыОтчетов.Дополнительный") Тогда
			Возврат "Дополнительный";
		ИначеЕсли ТипОтчета = ПредопределенноеЗначение("Перечисление.ТипыОтчетов.Внешний") Тогда
			Возврат "Внешний";
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Если ТипТипаОтчета <> Тип("Тип") Тогда
			ТипОтчета = ТипЗнч(Отчет);
		КонецЕсли;
		Если ТипОтчета = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
			Возврат "Внутренний";
		ИначеЕсли ТипОтчета = Тип("СправочникСсылка.ИдентификаторыОбъектовРасширений") Тогда
			Возврат "Расширение";
		ИначеЕсли ТипОтчета = Тип("Строка") Тогда
			Возврат "Внешний";
		Иначе
			Возврат "Дополнительный";
		КонецЕсли;
	КонецЕсли;
КонецФункции

// Превращает тип отчета в строковый идентификатор.
Функция ТипОтчета(ОтчетСсылка, РезультатСтрокой = Ложь) Экспорт
	ТипСсылки = ТипЗнч(ОтчетСсылка);
	Если ТипСсылки = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		Ключ = "Внутренний";
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.ИдентификаторыОбъектовРасширений") Тогда
		Ключ = "Расширение";
	ИначеЕсли ТипСсылки = Тип("Строка") Тогда
		Ключ = "Внешний";
	ИначеЕсли ТипСсылки = ТипСсылкиДополнительногоОтчета() Тогда
		Ключ = "Дополнительный";
	Иначе
		Ключ = ?(РезультатСтрокой, Неопределено, "ПустаяСсылка");
	КонецЕсли;
	Возврат ?(РезультатСтрокой, Ключ, ПредопределенноеЗначение("Перечисление.ТипыОтчетов." + Ключ));
КонецФункции

// Возвращает тип ссылки дополнительного отчета.
Функция ТипСсылкиДополнительногоОтчета() Экспорт
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Существует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки");
	#Иначе
		Существует = ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки");
	#КонецЕсли
	Если Существует Тогда
		Имя = "ДополнительныеОтчетыИОбработки";
		Возврат Тип("СправочникСсылка." + Имя);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

#КонецОбласти
