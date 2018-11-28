﻿// Ожидаются параметры:
//
//     ОбластьПоискаДублей        - Строка               - Полное имя метаданных таблицы ранее выбранной области поиска.
//     ПредставлениеОбластиОтбора - Строка               - Представление для формирования заголовка.
//     ОписаниеПрикладныхПравил   - Строка, Неопределено - Текст прикладных правил. Если не указано, то прикладных
//                                  правил нет.
//
//     АдресНастроек - Строка - Адрес временного хранилища настроек. Ожидается структура с полями:
//         УчитыватьПрикладныеПравила - Булево - Предыдущий флаг настройки, по умолчанию Истина.
//         ПравилаПоиска              - ТаблицаЗначений - Редактируемые настройки. Ожидаются колонки:
//             Реквизит - Строка  - Имя реквизита для сравнения.
//             ПредставлениеРеквизита - Строка - Представление реквизита для сравнения.
//             Правило - Строка  - Выбранный вариант сравнения: "Равно" - совпадение по равенству, "Подобно" -
//                                 совпадение по похожести, "" - не учитывать.
//             ВариантыСравнения - СписокЗначений - Доступные варианты сравнения, где значение - одно из вариантов
//                                                  правил.
//
// Возвращается результатом выбора:
//     Неопределено - Отказ от редактирования.
//     Строка       - Адрес временного хранилища новых настроек, указывает на структуру аналогичную параметру
//                    АдресНастроек.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ОписаниеПрикладныхПравил", ОписаниеПрикладныхПравил);
	ОбластьПоискаДублей = Параметры.ОбластьПоискаДублей;

	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Правила поиска дублей ""%1""'"), Параметры.ПредставлениеОбластиОтбора);
	
	ИсходныеНастройки = ПолучитьИзВременногоХранилища(Параметры.АдресНастроек);
	УдалитьИзВременногоХранилища(Параметры.АдресНастроек);
	ИсходныеНастройки.Свойство("УчитыватьПрикладныеПравила", УчитыватьПрикладныеПравила);
	
	Если ОписаниеПрикладныхПравил = Неопределено Тогда // Правила не определены
		Элементы.ГруппаПрикладныхОграничений.Видимость = Ложь;
		КлючСохраненияПоложенияОкна = "БезГруппыПрикладныхОграничений";
	Иначе
		Элементы.УчитыватьПрикладныеПравила.Видимость = МожноОтменятьПрикладныеПравила();
	КонецЕсли;
	
	// Заливаем и корректируем правила.
	ПравилаПоиска.Загрузить(ИсходныеНастройки.ПравилаПоиска);
	Для Каждого СтрокаПравила Из ПравилаПоиска Цикл
		СтрокаПравила.Использовать = Не ПустаяСтрока(СтрокаПравила.Правило);
	КонецЦикла;
	
	Для Каждого Элемент Из ИсходныеНастройки.ВсеВариантыСравнения Цикл
		Если Не ПустаяСтрока(Элемент.Значение) Тогда
			ЗаполнитьЗначенияСвойств(ВсеВидыСравненияПравилПоиска.Добавить(), Элемент);
		КонецЕсли;
	КонецЦикла;
	
	УстановитьЦветаИУсловноеОформление();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтотОбъект.ОбновитьОтображениеДанных();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УчитыватьПрикладныеПравилаПриИзменении(Элемент)
	
	Если УчитыватьПрикладныеПравила Тогда
		Возврат;
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ЗавершениеОчисткиИспользованияПрикладныхПравил", ЭтотОбъект);
	
	ТекстЗаголовка = НСтр("ru = 'Предупреждение'");
	ТекстВопроса   = НСтр("ru = 'Внимание: поиск и удаление дублей элементов без учета поставляемых ограничений
	                            |может привести к рассогласованию данных в программе.
	                            |
	                            |Отключить использование поставляемых ограничений?'");
	
	ПоказатьВопрос(Описание, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет, ТекстЗаголовка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыПравилаПоиска

&НаКлиенте
Процедура ПравилаПоискаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ИмяКолонки = Поле.Имя;
	Если ИмяКолонки = "ПравилаПоискаВидСравнения" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбратьВидСравнения();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПоискаИспользоватьПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.ПравилаПоиска.ТекущиеДанные;
	Если СтрокаТаблицы.Использовать Тогда
		Если ПустаяСтрока(СтрокаТаблицы.Правило) И СтрокаТаблицы.ВариантыСравнения.Количество() > 0 Тогда
			СтрокаТаблицы.Правило = СтрокаТаблицы.ВариантыСравнения[0].Значение
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПоискаВидСравненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьВидСравнения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандыФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	ТекстОшибокВыбора = ОшибкиВыбора();
	Если ТекстОшибокВыбора <> Неопределено Тогда
		ПоказатьПредупреждение(, ТекстОшибокВыбора);
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(РезультатВыбора());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьВидСравнения()
	СтрокаТаблицы = Элементы.ПравилаПоиска.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыбора = СтрокаТаблицы.ВариантыСравнения;
	Количество = СписокВыбора.Количество();
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура("СтрокаИдентификатор", СтрокаТаблицы.ПолучитьИдентификатор());
	Обработчик = Новый ОписаниеОповещения("ЗавершениеВыбораВидаСравнения", ЭтотОбъект, Контекст);
	Если Количество = 1 И Не СтрокаТаблицы.Использовать Тогда
		ВыполнитьОбработкуОповещения(Обработчик, СписокВыбора[0]);
		Возврат;
	КонецЕсли;
	
	ПоказатьВыборИзМеню(Обработчик, СписокВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораВидаСравнения(Результат, Контекст) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = ПравилаПоиска.НайтиПоИдентификатору(Контекст.СтрокаИдентификатор);
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы.Правило      = Результат.Значение;
	СтрокаТаблицы.Использовать = Истина;
КонецПроцедуры

&НаКлиенте
Функция ОшибкиВыбора()
	
	Если ОписаниеПрикладныхПравил <> Неопределено И УчитыватьПрикладныеПравила Тогда
		// Есть прикладные правила и они используются - ошибок нет.
		Возврат Неопределено;
	КонецЕсли;
	
	Для Каждого СтрокаПравил Из ПравилаПоиска Цикл
		Если СтрокаПравил.Использовать Тогда
			// Задано пользовательское правило - ошибок нет.
			Возврат Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НСтр("ru ='Необходимо указать хотя бы одно правило поиска дублей.'");
КонецФункции

&НаКлиенте
Процедура ЗавершениеОчисткиИспользованияПрикладныхПравил(Знач Ответ, Знач ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Возврат 
	КонецЕсли;
	
	УчитыватьПрикладныеПравила = Истина;
КонецПроцедуры

&НаСервереБезКонтекста
Функция МожноОтменятьПрикладныеПравила()
	
	Результат = ПравоДоступа("АдминистрированиеДанных", Метаданные);
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РезультатВыбора()
	
	Результат = Новый Структура;
	Результат.Вставить("УчитыватьПрикладныеПравила", УчитыватьПрикладныеПравила);
	
	ВыбранныеПравила = ПравилаПоиска.Выгрузить();
	Для Каждого СтрокаПравил Из ВыбранныеПравила  Цикл
		Если Не СтрокаПравил.Использовать Тогда
			СтрокаПравил.Правило = "";
		КонецЕсли;
	КонецЦикла;
	ВыбранныеПравила.Колонки.Удалить("Использовать");
	
	Результат.Вставить("ПравилаПоиска", ВыбранныеПравила );
	
	Возврат ПоместитьВоВременноеХранилище(Результат);
КонецФункции

&НаСервере
Процедура УстановитьЦветаИУсловноеОформление()
	ЭлементыУсловногоОформления = УсловноеОформление.Элементы;
	ЭлементыУсловногоОформления.Очистить();
	
	ЦветНедоступныеДанные = ЦветСтиляИлиАвто("ЦветНедоступныеДанные", 192, 192, 192);
	
	Для Каждого ЭлементСписка Из ВсеВидыСравненияПравилПоиска Цикл
		ЭлементОформления = ЭлементыУсловногоОформления.Добавить();
		
		ОтборОформления = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборОформления.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПравилаПоиска.Правило");
		ОтборОформления.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборОформления.ПравоеЗначение = ЭлементСписка.Значение;
		
		ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
		ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ПравилаПоискаВидСравнения");
		
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ЭлементСписка.Представление);
	КонецЦикла;
	
	// Не использовать
	ЭлементОформления = ЭлементыУсловногоОформления.Добавить();
	
	ОтборОформления = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборОформления.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПравилаПоиска.Использовать");
	ОтборОформления.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОформления.ПравоеЗначение = Ложь;
	
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ПравилаПоискаВидСравнения");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветНедоступныеДанные);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЦветСтиляИлиАвто(Знач Имя, Знач Красный = Неопределено, Зеленый = Неопределено, Синий = Неопределено)

	ЭлементСтиля = Метаданные.ЭлементыСтиля.Найти(Имя);
	Если ЭлементСтиля <> Неопределено И ЭлементСтиля.Вид = Метаданные.СвойстваОбъектов.ВидЭлементаСтиля.Цвет Тогда
		Возврат ЦветаСтиля[Имя];
	КонецЕсли;
	
	Возврат ?(Красный = Неопределено, Новый Цвет, Новый Цвет(Красный, Зеленый, Синий));
КонецФункции

#КонецОбласти

