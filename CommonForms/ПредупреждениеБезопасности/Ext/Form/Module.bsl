﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ТекстОшибки = НСтр("ru = 'Общая форма ""Предупреждение безопасности"" является вспомогательной и открывается из служебных механизмов программы.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ТекущаяСтраница = Элементы.Найти(Параметры.Ключ);
	Для Каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		Страница.Видимость = (Страница = ТекущаяСтраница);
	КонецЦикла;
	Элементы.Страницы.ТекущаяСтраница = ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ПослеОбновления Тогда
		Элементы.ЗапретитьОткрытиеВнешнихОтчетовИОбработок.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ТекущаяСтраница = Элементы.ПослеПоявленияПрава Тогда
		Элементы.ЯОзнакомлен.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	КлючНазначенияИспользования = Параметры.Ключ;
	КлючСохраненияПоложенияОкна = Параметры.Ключ;
	
	Если Не ПустаяСтрока(Параметры.ИмяФайла) Тогда
		Элементы.ПредупрежденииПриОткрытииФайла.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Элементы.ПредупрежденииПриОткрытииФайла.Заголовок, Параметры.ИмяФайла);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПродолжить(Команда)
	ИмяНажатойКнопки = Команда.Имя;
	ЗакрытьФормуИВернутьРезультат();
КонецПроцедуры

&НаКлиенте
Процедура ЗапретитьОткрытиеВнешнихОтчетовИОбработок(Команда)
	РазрешитьИнтерактивноеОткрытие = Ложь;
	УправлениеРольюНаКлиенте(Команда);
КонецПроцедуры

&НаКлиенте
Процедура НеЗапрещатьОткрытиеВнешнихОтчетовИОбработок(Команда)
	РазрешитьИнтерактивноеОткрытие = Истина;
	УправлениеРольюНаКлиенте(Команда);
КонецПроцедуры

&НаКлиенте
Процедура ЯОзнакомлен(Команда)
	ИмяНажатойКнопки = Команда.Имя;
	ЯОзнакомленНаСервере();
	ЗакрытьФормуИВернутьРезультат();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеРольюНаКлиенте(Команда)
	ИмяНажатойКнопки = Команда.Имя;
	УправлениеРольюНаСервере();
	ОбновитьПовторноИспользуемыеЗначения();
	ПредложитьПерезапуск();
КонецПроцедуры

&НаСервере
Процедура УправлениеРольюНаСервере()
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		Возврат;
	КонецЕсли;
	РольОткрытие = Метаданные.Роли.ИнтерактивноеОткрытиеВнешнихОтчетовИОбработок;
	РольАдминистратора = Метаданные.Роли.АдминистраторСистемы;
	
	ПараметрыАдминистрирования = СтандартныеПодсистемыСервер.ПараметрыАдминистрирования();
	ПараметрыАдминистрирования.Вставить("ПринятоРешениеПоОткрытиюВнешнихОтчетовИОбработок", Истина);
	СтандартныеПодсистемыСервер.УстановитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		Если РазрешитьИнтерактивноеОткрытие Тогда
			Если ПользовательИБ.Роли.Содержит(РольАдминистратора)
				И Не ПользовательИБ.Роли.Содержит(РольОткрытие) Тогда
				ПользовательИБ.Роли.Добавить(РольОткрытие);
				ПользовательИБ.Записать();
			КонецЕсли;
		Иначе
			Если ПользовательИБ.Роли.Содержит(РольОткрытие) Тогда
				ПользовательИБ.Роли.Удалить(РольОткрытие);
				ПользовательИБ.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если РазрешитьИнтерактивноеОткрытие Тогда
		НуженПерезапуск = Не ПравоДоступа("ИнтерактивноеОткрытиеВнешнихОбработок", Метаданные);
	Иначе
		НуженПерезапуск = ПравоДоступа("ИнтерактивноеОткрытиеВнешнихОбработок", Метаданные);
	КонецЕсли;
	
	ЯОзнакомленНаСервере();
	
	// В модели сервиса право открытия внешних отчетов и обработок
	// не используется для пользователей областей данных.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.УстановитьПравоОткрытияВнешнихОтчетовИОбработок(РазрешитьИнтерактивноеОткрытие);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЯОзнакомленНаСервере()
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПредупреждениеБезопасности", "ПользовательОзнакомлен", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуИВернутьРезультат()
	Если Открыта() Тогда
		ОповеститьОВыборе(ИмяНажатойКнопки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьПерезапуск()
	Если Не НуженПерезапуск Тогда
		ЗакрытьФормуИВернутьРезультат();
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ПерезапуститьПрограмму", ЭтотОбъект);
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Перезапустить", НСтр("ru = 'Перезапустить'"));
	Кнопки.Добавить("НеПерезапускать", НСтр("ru = 'Не перезапускать'"));
	ТекстВопроса = НСтр("ru = 'Для применения изменений требуется перезапустить программу.'");
	ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки);
КонецПроцедуры

&НаКлиенте
Процедура ПерезапуститьПрограмму(Ответ, ПараметрыВыполнения) Экспорт
	ЗакрытьФормуИВернутьРезультат();
	Если Ответ = "Перезапустить" Тогда
		ЗавершитьРаботуСистемы(Ложь, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
