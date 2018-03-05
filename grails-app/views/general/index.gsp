<g:form controller="general" action="agencies">
    <label>Address</label>
    <g:textField name="address" value="colon 100" />
    <label>Range</label>
    <g:textField name="range" value="900000" />
    <label>Payment Method</label>
    <select name="payment_method">
        <g:each in="${listPaymentMethods}" var="p">
            <option value="${p.id}">${p.name}</option>
        </g:each>
    </select>
    <button type="submit">Search</button>
</g:form>
