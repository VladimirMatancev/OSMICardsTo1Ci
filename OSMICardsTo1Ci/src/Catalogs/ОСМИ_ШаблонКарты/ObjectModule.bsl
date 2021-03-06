Процедура ОбновитьССервера() Экспорт
	ДанныеШаблона = ОСМИ_РаботаСAPI.ЗапроситьИнформациюОШаблоне(Наименование);
	Если ДанныеШаблона.Успех тогда
		МассивПолей = ДанныеШаблона.Ответ.values;
		ПоляШаблона.Очистить();
		Для Каждого Поле Из МассивПолей Цикл
			Стр = ПоляШаблона.Добавить();
			Стр.Имя = Поле.Label;
			Стр.ОтправлятьПУШ = Истина;
			Стр.ТекстОповещения = Поле.changeMsg;
			Если СтрДлина(СокрЛП(Поле.value)) > 0 Тогда
				Стр.СпособПолучения =  Поле.value;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
