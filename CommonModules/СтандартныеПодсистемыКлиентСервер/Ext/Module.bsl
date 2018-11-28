﻿#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Табличный документ

// Рассчитывает показатели числовых ячеек в табличном документе.
// См. также ОтчетыКлиент.ВыделенныеОбласти.
//
// Параметры:
//   ТабличныйДокумент - ТабличныйДокумент - таблица, для которой требуется расчет.
//   ВыделенныеОбласти
//       - Неопределено - при вызове с клиента этот параметр будет определен автоматически.
//       - Массив - При вызове с сервера в этот параметр следует передавать области,
//           предварительно вычисленные на клиенте
//           при помощи функции ОтчетыКлиент.ВыделенныеОбласти(ТабличныйДокумент).
//
// Возвращаемое значение:
//   Структура - результаты расчета выделенных ячеек.
//       * Количество         - Число - Количество выделенных ячеек.
//       * КоличествоЧисловых - Число - Количество числовых ячеек.
//       * Сумма      - Число - Сумма выделенных ячеек с числами.
//       * Среднее    - Число - Сумма выделенных ячеек с числами.
//       * Минимум    - Число - Сумма выделенных ячеек с числами.
//       * Максимум   - Число - Максимум выделенных ячеек с числами.
//       * НуженВызовСервера - Булево - Истина когда вычисление на клиенте нецелесообразно и нужен вызов сервера.
//
Функция РасчетЯчеек(ТабличныйДокумент, ВыделенныеОбласти) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Количество", 0);
	Результат.Вставить("КоличествоНеПустых", 0);
	Результат.Вставить("КоличествоЧисловых", 0);
	Результат.Вставить("Сумма", 0);
	Результат.Вставить("Среднее", 0);
	Результат.Вставить("Минимум", Неопределено);
	Результат.Вставить("Максимум", Неопределено);
	Результат.Вставить("НуженВызовСервера", Ложь);
	
	Если ВыделенныеОбласти = Неопределено Тогда
		#Если Клиент Тогда
			ВыделенныеОбласти = ТабличныйДокумент.ВыделенныеОбласти;
		#Иначе
			ВызватьИсключение НСтр("ru = 'Не указано значение параметра ""ВыделенныеОбласти"".'");
		#КонецЕсли
	КонецЕсли;
	
	ПроверенныеЯчейки = Новый Соответствие;
	
	Для Каждого ВыделеннаяОбласть Из ВыделенныеОбласти Цикл
		Если ТипЗнч(ВыделеннаяОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента")
			И ТипЗнч(ВыделеннаяОбласть) <> Тип("Структура") Тогда
			Продолжить;
		КонецЕсли;
		
		ВыделеннаяОбластьВерх  = ВыделеннаяОбласть.Верх;
		ВыделеннаяОбластьНиз   = ВыделеннаяОбласть.Низ;
		ВыделеннаяОбластьЛево  = ВыделеннаяОбласть.Лево;
		ВыделеннаяОбластьПраво = ВыделеннаяОбласть.Право;
		
		Если ВыделеннаяОбластьВерх = 0 Тогда
			ВыделеннаяОбластьВерх = 1;
		КонецЕсли;
		
		Если ВыделеннаяОбластьНиз = 0 Тогда
			ВыделеннаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
		
		Если ВыделеннаяОбластьЛево = 0 Тогда
			ВыделеннаяОбластьЛево = 1;
		КонецЕсли;
		
		Если ВыделеннаяОбластьПраво = 0 Тогда
			ВыделеннаяОбластьПраво = ТабличныйДокумент.ШиринаТаблицы;
		КонецЕсли;
		
		Если ВыделеннаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
			ВыделеннаяОбластьВерх = ВыделеннаяОбласть.Низ;
			ВыделеннаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
		
		ВыделеннаяОбластьВысота = ВыделеннаяОбластьНиз   - ВыделеннаяОбластьВерх + 1;
		ВыделеннаяОбластьШирина = ВыделеннаяОбластьПраво - ВыделеннаяОбластьЛево + 1;
		
		Результат.Количество = Результат.Количество + ВыделеннаяОбластьШирина * ВыделеннаяОбластьВысота;
		#Если Клиент И Не ТолстыйКлиентОбычноеПриложение Тогда
			Если Результат.Количество >= 1000 Тогда
				Результат.НуженВызовСервера = Истина;
				Возврат Результат;
			КонецЕсли;
		#КонецЕсли
		
		Для НомерКолонки = ВыделеннаяОбластьЛево По ВыделеннаяОбластьПраво Цикл
			Для НомерСтроки = ВыделеннаяОбластьВерх По ВыделеннаяОбластьНиз Цикл
				Ячейка = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
				Если ПроверенныеЯчейки.Получить(Ячейка.Имя) = Неопределено Тогда
					ПроверенныеЯчейки.Вставить(Ячейка.Имя, Истина);
				Иначе
					Продолжить;
				КонецЕсли;
				
				Если Ячейка.Видимость = Истина Тогда
					Если Ячейка.ТипОбласти <> ТипОбластиЯчеекТабличногоДокумента.Колонки
						И Ячейка.СодержитЗначение И ТипЗнч(Ячейка.Значение) = Тип("Число") Тогда
						Число = Ячейка.Значение;
					ИначеЕсли ЗначениеЗаполнено(Ячейка.Текст) Тогда
						ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
						Число = ОписаниеТипаЧисло.ПривестиЗначение(Ячейка.Текст);
					Иначе
						Продолжить;
					КонецЕсли;
					Результат.КоличествоНеПустых = Результат.КоличествоНеПустых + 1;
					Если ТипЗнч(Число) = Тип("Число") Тогда
						Результат.КоличествоЧисловых = Результат.КоличествоЧисловых + 1;
						Результат.Сумма = Результат.Сумма + Число;
						Если Результат.КоличествоЧисловых = 1 Тогда
							Результат.Минимум  = Число;
							Результат.Максимум = Число;
						Иначе
							Результат.Минимум  = Мин(Число,  Результат.Минимум);
							Результат.Максимум = Макс(Число, Результат.Максимум);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если Результат.КоличествоЧисловых > 0 Тогда
		Результат.Среднее = Результат.Сумма / Результат.КоличествоЧисловых;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с расписанием регламентного задания.

// Формирует представление расписания регламентного задания.
//
// Параметры:
//   Расписание - РасписаниеРегламентногоЗадания - Расписание.
//
// Возвращаемое значение:
//   Строка - Представление расписания.
//
Функция ПредставлениеРасписания(Расписание) Экспорт
	ПредставлениеРасписания = Строка(Расписание);
	ПредставлениеРасписания = ВРег(Лев(ПредставлениеРасписания, 1)) + Сред(ПредставлениеРасписания, 2);
	ПредставлениеРасписания = СтрЗаменить(СтрЗаменить(ПредставлениеРасписания, "  ", " "), " ]", "]") + ".";
	Возврат ПредставлениеРасписания;
КонецФункции

#КонецОбласти

